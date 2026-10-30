import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Listing, ListingStatus } from '../types/models'
import { INITIAL_LISTINGS, DOCUMENT_TYPE_LABELS } from '../data/seed'
import { useAuditStore } from './auditStore'

export const useListingsStore = defineStore('listings', () => {
  const listings = ref<Listing[]>(INITIAL_LISTINGS.map((l) => ({ ...l })))
  const statusFilter = ref<'All' | ListingStatus>('All')
  const searchQuery = ref('')
  const auditStore = useAuditStore()

  const liveCount = computed(() => listings.value.filter((l) => l.st === 'Live').length)
  const recoveredCount = computed(() => listings.value.filter((l) => l.st === 'Recovered').length)
  const archivedCount = computed(() => listings.value.filter((l) => l.st === 'Archived').length)

  const filteredListings = computed(() => {
    return listings.value.filter((l) => {
      const matchesStatus = statusFilter.value === 'All' || l.st === statusFilter.value
      if (!matchesStatus) return false

      if (!searchQuery.value.trim()) return true
      const q = searchQuery.value.toLowerCase().trim()
      const docTypeLabel = DOCUMENT_TYPE_LABELS[l.type].toLowerCase()
      const town = l.town.toLowerCase()
      return docTypeLabel.includes(q) || town.includes(q)
    })
  })

  function setStatusFilter(filter: 'All' | ListingStatus) {
    statusFilter.value = filter
  }

  function setSearchQuery(q: string) {
    searchQuery.value = q
  }

  function updateListingStatus(id: number, newStatus: ListingStatus) {
    const item = listings.value.find((l) => l.id === id)
    if (item) {
      item.st = newStatus
      const label = DOCUMENT_TYPE_LABELS[item.type]
      auditStore.log(`set listing ${label} · ${item.town} to ${newStatus}`)
    }
  }

  function addListing(listing: Listing) {
    listings.value.unshift(listing)
  }

  return {
    listings,
    statusFilter,
    searchQuery,
    liveCount,
    recoveredCount,
    archivedCount,
    filteredListings,
    setStatusFilter,
    setSearchQuery,
    updateListingStatus,
    addListing
  }
})
