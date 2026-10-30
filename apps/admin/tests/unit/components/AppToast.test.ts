import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppToast from '../../../src/components/common/AppToast.vue'
import { useToast } from '../../../src/composables/useToast'

describe('AppToast', () => {
  it('renders toast message when active', async () => {
    const { showToast } = useToast()
    const wrapper = mount(AppToast)

    expect(wrapper.classes()).toContain('opacity-0')

    showToast('Listing archived')
    await wrapper.vm.$nextTick()

    expect(wrapper.text()).toContain('Listing archived')
    expect(wrapper.classes()).toContain('opacity-100')
  })
})
