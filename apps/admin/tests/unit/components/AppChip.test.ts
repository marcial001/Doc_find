import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppChip from '../../../src/components/common/AppChip.vue'

describe('AppChip', () => {
  it('renders default chip and handles active state', () => {
    const inactive = mount(AppChip, {
      slots: { default: 'Douala' }
    })
    expect(inactive.text()).toBe('Douala')
    expect(inactive.classes()).toContain('border-line')

    const active = mount(AppChip, {
      props: { active: true },
      slots: { default: 'Yaoundé' }
    })
    expect(active.classes()).toContain('bg-g')
  })

  it('emits click event', async () => {
    const wrapper = mount(AppChip)
    await wrapper.trigger('click')
    expect(wrapper.emitted('click')).toHaveLength(1)
  })
})
