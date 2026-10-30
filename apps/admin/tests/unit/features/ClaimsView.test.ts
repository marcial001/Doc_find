import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import ClaimsView from '../../../src/features/claims/ClaimsView.vue'
import { useClaimsStore } from '../../../src/stores/claimsStore'

describe('ClaimsView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders master list of claims with risk and status pills', () => {
    const wrapper = mount(ClaimsView)
    expect(wrapper.text()).toContain('Kevin Nkeng')
    expect(wrapper.text()).toContain('Low risk')
    expect(wrapper.text()).toContain('PROOF OF OWNERSHIP')
    expect(wrapper.text()).toContain('Document says')
    expect(wrapper.text()).toContain('Claimant answered')
  })

  it('sends chat message and supports quick reply chips', async () => {
    const store = useClaimsStore()
    const first = store.claims[0]
    store.selectClaim(first.id)

    const wrapper = mount(ClaimsView)
    const quickChip = wrapper.findAll('button').find((b) => b.text().includes('Please bring your original ID'))
    expect(quickChip).toBeDefined()

    await quickChip?.trigger('click')
    expect(first.msgs.some((m) => m[1].includes('Please bring your original ID'))).toBe(true)
  })

  it('triggers request more proof action', async () => {
    const store = useClaimsStore()
    const first = store.claims[0]
    store.selectClaim(first.id)

    const wrapper = mount(ClaimsView)
    const moreBtn = wrapper.findAll('button').find((b) => b.text() === 'Request more proof')
    await moreBtn?.trigger('click')

    expect(first.st).toBe('more')
  })

  it('triggers reject and flag action', async () => {
    const store = useClaimsStore()
    const first = store.claims[0]
    store.selectClaim(first.id)

    const wrapper = mount(ClaimsView)
    const rejBtn = wrapper.findAll('button').find((b) => b.text() === 'Reject and flag')
    await rejBtn?.trigger('click')

    expect(first.st).toBe('rejected')
  })
})
