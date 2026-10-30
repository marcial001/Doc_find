import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useListingsStore } from '../../../src/stores/listingsStore'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('listingsStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with seed listings and calculates counts', () => {
    const store = useListingsStore()
    expect(store.listings.length).toBeGreaterThan(0)
    expect(store.liveCount).toBe(store.listings.filter((l) => l.st === 'Live').length)
    expect(store.recoveredCount).toBe(store.listings.filter((l) => l.st === 'Recovered').length)
    expect(store.archivedCount).toBe(store.listings.filter((l) => l.st === 'Archived').length)
  })

  it('filters listings by status', () => {
    const store = useListingsStore()
    store.setStatusFilter('Live')
    expect(store.filteredListings.every((l) => l.st === 'Live')).toBe(true)

    store.setStatusFilter('Recovered')
    expect(store.filteredListings.every((l) => l.st === 'Recovered')).toBe(true)

    store.setStatusFilter('All')
    expect(store.filteredListings.length).toBe(store.listings.length)
  })

  it('filters listings by search query (town or document type)', () => {
    const store = useListingsStore()
    store.setSearchQuery('Douala')
    expect(store.filteredListings.every((l) => l.town.toLowerCase().includes('douala'))).toBe(true)

    store.setSearchQuery('Passport')
    expect(store.filteredListings.every((l) => l.type === 'pass')).toBe(true)
  })

  it('updates listing status and logs to audit', () => {
    const store = useListingsStore()
    const auditStore = useAuditStore()
    const first = store.listings[0]

    store.updateListingStatus(first.id, 'Recovered')
    expect(first.st).toBe('Recovered')
    expect(auditStore.events[0].w).toContain('set listing')
    expect(auditStore.events[0].w).toContain('Recovered')
  })

  it('prepends a new listing', () => {
    const store = useListingsStore()
    const prevCount = store.listings.length
    store.addListing({
      id: 999,
      type: 'id',
      town: 'Kumba',
      days: 0,
      st: 'Live',
      views: 0,
      cl: 0
    })
    expect(store.listings.length).toBe(prevCount + 1)
    expect(store.listings[0].id).toBe(999)
  })
})
