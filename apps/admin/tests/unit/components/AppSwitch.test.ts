import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppSwitch from '../../../src/components/common/AppSwitch.vue'

describe('AppSwitch', () => {
  it('renders switch with accessibility attributes', () => {
    const wrapper = mount(AppSwitch, {
      props: { modelValue: true, label: 'Enable notifications' }
    })
    expect(wrapper.attributes('role')).toBe('switch')
    expect(wrapper.attributes('aria-checked')).toBe('true')
    expect(wrapper.attributes('aria-label')).toBe('Enable notifications')
    expect(wrapper.classes()).toContain('bg-g')
  })

  it('emits update:modelValue and change events on click', async () => {
    const wrapper = mount(AppSwitch, {
      props: { modelValue: false }
    })
    await wrapper.trigger('click')
    expect(wrapper.emitted('update:modelValue')?.[0]).toEqual([true])
    expect(wrapper.emitted('change')?.[0]).toEqual([true])
  })

  it('does not emit events when disabled', async () => {
    const wrapper = mount(AppSwitch, {
      props: { modelValue: false, disabled: true }
    })
    await wrapper.trigger('click')
    expect(wrapper.emitted('update:modelValue')).toBeUndefined()
  })
})
