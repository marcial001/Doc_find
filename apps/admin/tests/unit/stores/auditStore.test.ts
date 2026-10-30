import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('auditStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with seed audit events', () => {
    const store = useAuditStore()
    expect(store.events.length).toBeGreaterThan(0)
    expect(store.showSensitiveOnly).toBe(false)
  })

  it('prepends a new standard audit log entry', () => {
    const store = useAuditStore()
    const initialCount = store.events.length
    store.log('approved a listing')

    expect(store.events.length).toBe(initialCount + 1)
    expect(store.events[0].w).toContain('Admin Antony approved a listing')
    expect(store.events[0].s).toBe(0)
  })

  it('prepends a new sensitive audit log entry', () => {
    const store = useAuditStore()
    store.log('revealed original document', true)

    expect(store.events[0].w).toContain('Admin Antony revealed original document')
    expect(store.events[0].s).toBe(1)
  })

  it('toggles sensitive filter and filters events accordingly', () => {
    const store = useAuditStore()
    expect(store.showSensitiveOnly).toBe(false)
    const allCount = store.filteredEvents.length

    store.toggleSensitiveFilter()
    expect(store.showSensitiveOnly).toBe(true)
    expect(store.filteredEvents.length).toBeLessThanOrEqual(allCount)
    expect(store.filteredEvents.every((e) => e.s === 1)).toBe(true)
  })
})
