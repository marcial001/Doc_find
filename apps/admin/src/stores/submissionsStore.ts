import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Submission, RedactionSettings, DocumentType } from '../types/models'
import { INITIAL_SUBMISSIONS, DOCUMENT_TYPE_LABELS, createDefaultRedaction } from '../data/seed'
import { useAuditStore } from './auditStore'
import { useListingsStore } from './listingsStore'

export const useSubmissionsStore = defineStore('submissions', () => {
  const submissions = ref<Submission[]>(
    INITIAL_SUBMISSIONS.map((s) => ({
      ...s,
      consent: [...s.consent] as [boolean, boolean, boolean],
      d: { ...s.d }
    }))
  )
  const selectedId = ref<number | null>(null)
  const redactions = ref<Record<number, RedactionSettings>>({})
  const revealed = ref<Record<number, boolean>>({})

  const auditStore = useAuditStore()
  const listingsStore = useListingsStore()

  const queueCount = computed(() => submissions.value.length)

  const selectedSubmission = computed(() => {
    if (selectedId.value === null) return null
    return submissions.value.find((s) => s.id === selectedId.value) || null
  })

  function selectSubmission(id: number | null) {
    selectedId.value = id
  }

  function getRedaction(id: number): RedactionSettings {
    if (!redactions.value[id]) {
      redactions.value[id] = createDefaultRedaction()
    }
    return redactions.value[id]
  }

  function toggleRedactionField(id: number, field: keyof RedactionSettings) {
    const r = getRedaction(id)
    if (typeof r[field] === 'boolean') {
      ;(r[field] as boolean) = !(r[field] as boolean)
    }
  }

  function setBlurStrength(id: number, strength: number) {
    const r = getRedaction(id)
    r.blur = strength
  }

  function isRevealed(id: number): boolean {
    return !!revealed.value[id]
  }

  function revealOriginal(id: number) {
    revealed.value[id] = true
    auditStore.log('revealed an original document photo (reason: redaction)', true)
  }

  function approveSubmission(id: number) {
    const item = submissions.value.find((s) => s.id === id)
    if (!item) return

    submissions.value = submissions.value.filter((s) => s.id !== id)
    listingsStore.addListing({
      id: 200 + id,
      type: item.type,
      town: item.town,
      days: 0,
      st: 'Live',
      views: 0,
      cl: 0
    })

    const label = DOCUMENT_TYPE_LABELS[item.type]
    auditStore.log(`approved listing: ${label} · ${item.town}`)

    if (selectedId.value === id) {
      selectedId.value = null
    }
  }

  function requestRetake(id: number) {
    const item = submissions.value.find((s) => s.id === id)
    if (!item) return
    const label = DOCUMENT_TYPE_LABELS[item.type]
    auditStore.log(`asked finder for a better photo: ${label} · ${item.town}`)
  }

  function rejectSubmission(id: number, reason: string) {
    const item = submissions.value.find((s) => s.id === id)
    if (!item) return

    submissions.value = submissions.value.filter((s) => s.id !== id)
    auditStore.log(`rejected submission (${reason})`)

    if (selectedId.value === id) {
      selectedId.value = null
    }
  }

  function addBulkSubmissions(partner: string, items: Array<{ type: DocumentType; town: string }>) {
    items.forEach((item, index) => {
      const newId = 300 + index + (Date.now() % 1000)
      submissions.value.push({
        id: newId,
        type: item.type,
        town: item.town,
        spot: partner,
        ago: 'Just now',
        finder: partner,
        tel: 'Partner batch',
        q: 'Sharp',
        consent: [true, true, true],
        d: {
          name: 'Sample Holder',
          num: `0000 0000 0${index + 1}`,
          dob: '01 Jan 1990',
          addr: item.town
        }
      })
    })

    auditStore.log(`bulk-uploaded ${items.length} documents from ${partner}`)
  }

  return {
    submissions,
    selectedId,
    selectedSubmission,
    queueCount,
    selectSubmission,
    getRedaction,
    toggleRedactionField,
    setBlurStrength,
    isRevealed,
    revealOriginal,
    approveSubmission,
    requestRetake,
    rejectSubmission,
    addBulkSubmissions
  }
})
