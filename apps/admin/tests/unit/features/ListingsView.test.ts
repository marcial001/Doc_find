import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import ListingsView from '../../../src/features/listings/ListingsView.vue'
import { useListingsStore } from '../../../src/stores/listingsStore'

describe('ListingsView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders listings table with auto-archive banner and filters', () => {
    const wrapper = mount(ListingsView)
    expect(wrapper.text()).toContain('Listings with no activity for')
    expect(wrapper.text()).toContain('Bulk post (CSV)')
    expect(wrapper.text()).toContain('Document')
    expect(wrapper.text()).toContain('Town')
    expect(wrapper.text()).toContain('Status')
  })

  it('filters rows when status chips are clicked', async () => {
    const store = useListingsStore()
    const wrapper = mount(ListingsView)

    const liveChip = wrapper.findAll('button').find((b) => b.text() === 'Live')
    await liveChip?.trigger('click')

    expect(store.statusFilter).toBe('Live')
  })

  it('changes status via row buttons', async () => {
    const store = useListingsStore()
    const wrapper = mount(ListingsView)

    const archiveBtn = wrapper.findAll('button').find((b) => b.text() === 'Archive')
    expect(archiveBtn).toBeDefined()
    await archiveBtn?.trigger('click')

    expect(store.listings.some((l) => l.st === 'Archived')).toBe(true)
  })
})
