import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import FraudView from '../../../src/features/fraud/FraudView.vue'
import { useFraudStore } from '../../../src/stores/fraudStore'

describe('FraudView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders fraud report cards with risk tags and reasons', () => {
    const wrapper = mount(FraudView)
    expect(wrapper.text()).toContain('Marie Tchoua')
    expect(wrapper.text()).toContain('Wrong birth date in proof')
    expect(wrapper.text()).toContain('Suspend user')
    expect(wrapper.text()).toContain('Dismiss')
  })

  it('suspends user when button is clicked', async () => {
    const store = useFraudStore()
    const first = store.reports[0]

    const wrapper = mount(FraudView)
    const suspendBtn = wrapper.findAll('button').find((b) => b.text() === 'Suspend user')
    await suspendBtn?.trigger('click')

    expect(first.st).toBe('Suspended')
  })

  it('dismisses report when button is clicked', async () => {
    const store = useFraudStore()
    const first = store.reports[0]

    const wrapper = mount(FraudView)
    const dismissBtn = wrapper.findAll('button').find((b) => b.text() === 'Dismiss')
    await dismissBtn?.trigger('click')

    expect(first.st).toBe('Dismissed')
  })
})
