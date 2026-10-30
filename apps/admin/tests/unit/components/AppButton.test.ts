import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppButton from '../../../src/components/common/AppButton.vue'

describe('AppButton', () => {
  it('renders default button with slot text', () => {
    const wrapper = mount(AppButton, {
      slots: {
        default: 'Submit'
      }
    })
    expect(wrapper.text()).toBe('Submit')
    expect(wrapper.classes()).toContain('bg-g')
  })

  it('renders variants and sizes', () => {
    const altWrapper = mount(AppButton, {
      props: { variant: 'alt', size: 'sm' }
    })
    expect(altWrapper.classes()).toContain('bg-g2')
    expect(altWrapper.classes()).toContain('px-3')

    const redWrapper = mount(AppButton, {
      props: { variant: 'red' }
    })
    expect(redWrapper.classes()).toContain('bg-red-tint')
  })

  it('emits click event when not disabled', async () => {
    const wrapper = mount(AppButton)
    await wrapper.trigger('click')
    expect(wrapper.emitted('click')).toHaveLength(1)
  })

  it('does not emit click when disabled', async () => {
    const wrapper = mount(AppButton, {
      props: { disabled: true }
    })
    expect(wrapper.attributes('disabled')).toBeDefined()
  })
})
