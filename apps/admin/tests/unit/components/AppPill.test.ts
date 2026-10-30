import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AppPill from '../../../src/components/common/AppPill.vue'

describe('AppPill', () => {
  it('renders default pill variant', () => {
    const wrapper = mount(AppPill, {
      slots: { default: 'Active' }
    })
    expect(wrapper.text()).toBe('Active')
    expect(wrapper.classes()).toContain('bg-g2')
  })

  it('renders warning, danger, and muted variants', () => {
    const w = mount(AppPill, { props: { variant: 'w' } })
    expect(w.classes()).toContain('bg-amb-tint')

    const r = mount(AppPill, { props: { variant: 'r' } })
    expect(r.classes()).toContain('bg-red-tint')

    const m = mount(AppPill, { props: { variant: 'm' } })
    expect(m.classes()).toContain('bg-bg')
  })
})
