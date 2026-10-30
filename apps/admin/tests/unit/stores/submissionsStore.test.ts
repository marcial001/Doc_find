import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useSubmissionsStore } from '../../../src/stores/submissionsStore'
import { useListingsStore } from '../../../src/stores/listingsStore'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('submissionsStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with seed submissions and calculates queueCount', () => {
    const store = useSubmissionsStore()
    expect(store.submissions.length).toBeGreaterThan(0)
    expect(store.queueCount).toBe(store.submissions.length)
    expect(store.selectedId).toBeNull()
    expect(store.selectedSubmission).toBeNull()
  })

  it('selects and deselects a submission', () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)
    expect(store.selectedId).toBe(first.id)
    expect(store.selectedSubmission?.id).toBe(first.id)

    store.selectSubmission(null)
    expect(store.selectedSubmission).toBeNull()
  })

  it('initializes default redactions and allows toggling fields', () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    const r = store.getRedaction(first.id)
    expect(r.name).toBe(true)
    expect(r.photo).toBe(true)

    store.toggleRedactionField(first.id, 'name')
    expect(store.getRedaction(first.id).name).toBe(false)

    store.setBlurStrength(first.id, 12)
    expect(store.getRedaction(first.id).blur).toBe(12)
  })

  it('reveals original document and logs sensitive event to audit log', () => {
    const store = useSubmissionsStore()
    const auditStore = useAuditStore()
    const first = store.submissions[0]

    expect(store.isRevealed(first.id)).toBe(false)
    store.revealOriginal(first.id)
    expect(store.isRevealed(first.id)).toBe(true)

    expect(auditStore.events[0].w).toContain('revealed an original document photo')
    expect(auditStore.events[0].s).toBe(1)
  })

  it('approves submission, publishes new live listing, and logs audit', () => {
    const store = useSubmissionsStore()
    const listingsStore = useListingsStore()
    const auditStore = useAuditStore()
    const initialListingsCount = listingsStore.listings.length
    const first = store.submissions[0]

    store.selectSubmission(first.id)
    store.approveSubmission(first.id)

    expect(store.submissions.some((s) => s.id === first.id)).toBe(false)
    expect(store.selectedId).toBeNull()
    expect(listingsStore.listings.length).toBe(initialListingsCount + 1)
    expect(listingsStore.listings[0].st).toBe('Live')
    expect(auditStore.events[0].w).toContain('approved listing')
  })

  it('requests retake and logs audit event', () => {
    const store = useSubmissionsStore()
    const auditStore = useAuditStore()
    const first = store.submissions[0]

    store.requestRetake(first.id)
    expect(auditStore.events[0].w).toContain('asked finder for a better photo')
  })

  it('rejects submission with reason, removes from queue, and logs audit', () => {
    const store = useSubmissionsStore()
    const auditStore = useAuditStore()
    const first = store.submissions[0]

    store.selectSubmission(first.id)
    store.rejectSubmission(first.id, 'Not an official document')

    expect(store.submissions.some((s) => s.id === first.id)).toBe(false)
    expect(store.selectedId).toBeNull()
    expect(auditStore.events[0].w).toContain('rejected submission (Not an official document)')
  })

  it('bulk adds partner submissions and logs audit', () => {
    const store = useSubmissionsStore()
    const auditStore = useAuditStore()
    const prevCount = store.submissions.length

    store.addBulkSubmissions('Prefecture of Wouri', [
      { type: 'id', town: 'Douala' },
      { type: 'birth', town: 'Garoua' }
    ])

    expect(store.submissions.length).toBe(prevCount + 2)
    expect(auditStore.events[0].w).toContain('bulk-uploaded 2 documents from Prefecture of Wouri')
  })
})
