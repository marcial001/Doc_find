import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useFraudStore } from '../../../src/stores/fraudStore'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('fraudStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with seed fraud reports and counts open reports', () => {
    const store = useFraudStore()
    expect(store.reports.length).toBeGreaterThan(0)
    expect(store.openCount).toBe(store.reports.filter((r) => r.st === 'open').length)
  })

  it('suspends user, marks report status, and logs sensitive event', () => {
    const store = useFraudStore()
    const auditStore = useAuditStore()
    const first = store.reports[0]

    store.suspendUser(first.id)
    expect(first.st).toBe('Suspended')
    expect(auditStore.events[0].w).toContain(`suspended user ${first.who}`)
    expect(auditStore.events[0].s).toBe(1)
  })

  it('dismisses report, marks report status, and logs standard audit event', () => {
    const store = useFraudStore()
    const auditStore = useAuditStore()
    const first = store.reports[0]

    store.dismissReport(first.id)
    expect(first.st).toBe('Dismissed')
    expect(auditStore.events[0].w).toContain(`dismissed report on ${first.who}`)
    expect(auditStore.events[0].s).toBe(0)
  })

  it('adds a new fraud report', () => {
    const store = useFraudStore()
    const prevCount = store.reports.length

    store.addReport({
      id: 888,
      who: 'Suspicious User',
      why: 'Multiple fake claims',
      by: 'Automatic rule',
      sev: 'High',
      st: 'open'
    })

    expect(store.reports.length).toBe(prevCount + 1)
    expect(store.reports[0].who).toBe('Suspicious User')
  })
})
