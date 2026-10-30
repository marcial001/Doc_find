import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import AuditView from '../../../src/features/audit/AuditView.vue'
import { useAuditStore } from '../../../src/stores/auditStore'

describe('AuditView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders audit events table and toggle button', () => {
    const wrapper = mount(AuditView)
    expect(wrapper.text()).toContain('Every admin action is recorded')
    expect(wrapper.text()).toContain('Show sensitive only')
    expect(wrapper.text()).toContain('revealed an original document photo')
    expect(wrapper.text()).toContain('Sensitive')
  })

  it('toggles sensitive filter when button is clicked', async () => {
    const store = useAuditStore()
    const wrapper = mount(AuditView)

    const toggleBtn = wrapper.findAll('button').find((b) => b.text().includes('sensitive'))
    await toggleBtn?.trigger('click')

    expect(store.showSensitiveOnly).toBe(true)
    expect(wrapper.text()).toContain('Show all')
  })
})
