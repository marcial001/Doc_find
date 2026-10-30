import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AuditEvent } from '../types/models'
import { INITIAL_AUDIT_EVENTS } from '../data/seed'
import { useAuthStore } from './authStore'

export const useAuditStore = defineStore('audit', () => {
  const events = ref<AuditEvent[]>(INITIAL_AUDIT_EVENTS.map((e) => ({ ...e })))
  const showSensitiveOnly = ref(false)
  const authStore = useAuthStore()

  const filteredEvents = computed(() => {
    if (!showSensitiveOnly.value) return events.value
    return events.value.filter((e) => e.s === 1)
  })

  function log(actionDescription: string, isSensitive: boolean = false) {
    const adminName = authStore.user.name
    events.value.unshift({
      t: 'Just now',
      w: `Admin ${adminName} ${actionDescription}`,
      s: isSensitive ? 1 : 0
    })
  }

  function toggleSensitiveFilter() {
    showSensitiveOnly.value = !showSensitiveOnly.value
  }

  return {
    events,
    showSensitiveOnly,
    filteredEvents,
    log,
    toggleSensitiveFilter
  }
})
