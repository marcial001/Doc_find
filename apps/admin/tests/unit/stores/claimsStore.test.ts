import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useClaimsStore } from '../../../src/stores/claimsStore'
import { useListingsStore } from '../../../src/stores/listingsStore'
import { useFraudStore } from '../../../src/stores/fraudStore'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('claimsStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.useFakeTimers()
  })

  it('initializes with seed claims and calculates newClaimsCount', () => {
    const store = useClaimsStore()
    expect(store.claims.length).toBeGreaterThan(0)
    expect(store.newClaimsCount).toBe(store.claims.filter((c) => c.st === 'new').length)
  })

  it('selects and deselects a claim', () => {
    const store = useClaimsStore()
    const first = store.claims[0]
    store.selectClaim(first.id)
    expect(store.selectedId).toBe(first.id)
    expect(store.selectedClaim?.id).toBe(first.id)

    store.selectClaim(null)
    expect(store.selectedClaim).toBeNull()
  })

  it('sends a chat message and triggers simulated claimant auto-reply', () => {
    const store = useClaimsStore()
    const first = store.claims[0]
    const initialMsgCount = first.msgs.length

    store.sendMessage(first.id, 'Can you send more proof?', true)
    expect(first.msgs.length).toBe(initialMsgCount + 1)
    expect(first.msgs[first.msgs.length - 1][0]).toBe('a')
    expect(first.msgs[first.msgs.length - 1][1]).toBe('Can you send more proof?')

    // Fast forward fake timers for auto-reply
    vi.advanceTimersByTime(1500)
    expect(first.msgs.length).toBe(initialMsgCount + 2)
    expect(first.msgs[first.msgs.length - 1][0]).toBe('u')
    expect(first.msgs[first.msgs.length - 1][1]).toContain('Thank you, I understand.')
  })

  it('verifies and arranges handoff', () => {
    const store = useClaimsStore()
    const auditStore = useAuditStore()
    const first = store.claims[0]

    store.verifyAndArrangeHandoff(first.id, 'Prefecture of Wouri', 'Tomorrow, 10:00')
    expect(first.st).toBe('handoff')
    expect(first.msgs[first.msgs.length - 1][1]).toContain('Prefecture of Wouri on Tomorrow, 10:00')
    expect(auditStore.events[0].w).toContain('verified claim and scheduled handoff')
  })

  it('requests more proof', () => {
    const store = useClaimsStore()
    const auditStore = useAuditStore()
    const first = store.claims[0]

    store.requestMoreProof(first.id)
    expect(first.st).toBe('more')
    expect(first.msgs[first.msgs.length - 1][1]).toContain('send a clear photo of your own ID')
    expect(auditStore.events[0].w).toContain(`requested more proof from ${first.who}`)
  })

  it('rejects and flags claimant, adding to fraud store and sensitive audit log', () => {
    const store = useClaimsStore()
    const fraudStore = useFraudStore()
    const auditStore = useAuditStore()
    const first = store.claims[0]
    const prevFraudCount = fraudStore.reports.length

    store.rejectAndFlag(first.id)
    expect(first.st).toBe('rejected')
    expect(fraudStore.reports.length).toBe(prevFraudCount + 1)
    expect(fraudStore.reports[0].who).toBe(first.who)
    expect(auditStore.events[0].s).toBe(1)
    expect(auditStore.events[0].w).toContain(`flagged ${first.who}`)
  })

  it('marks claim as handed over and sets matching listing status to Recovered', () => {
    const store = useClaimsStore()
    const listingsStore = useListingsStore()
    const auditStore = useAuditStore()
    const first = store.claims[0] // Douala id card

    store.markHandedOver(first.id)
    expect(first.st).toBe('done')

    const matchingListing = listingsStore.listings.find(
      (l) => l.type === first.type && l.town === first.town
    )
    expect(matchingListing?.st).toBe('Recovered')
    expect(auditStore.events[0].w).toContain('marked handed over')
  })
})
