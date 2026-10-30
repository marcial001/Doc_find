import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import SettingsView from '../../../src/features/settings/SettingsView.vue'
import { useSettingsStore } from '../../../src/stores/settingsStore'
import { i18n } from '../../../src/i18n'

describe('SettingsView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders moderation and privacy settings sections', () => {
    const wrapper = mount(SettingsView, {
      global: { plugins: [i18n] }
    })
    expect(wrapper.text()).toContain('Moderation')
    expect(wrapper.text()).toContain('Privacy (Law No. 2024/017)')
    expect(wrapper.text()).toContain('Require proof-of-ownership answer')
    expect(wrapper.text()).toContain('Auto-archive inactive listings')
  })

  it('changes auto-archive period via select dropdown', async () => {
    const store = useSettingsStore()
    const wrapper = mount(SettingsView, {
      global: { plugins: [i18n] }
    })

    const select = wrapper.findAll('select')[0]
    await select.setValue(60)
    await select.trigger('change')

    expect(store.settings.days).toBe(60)
  })

  it('changes language via buttons', async () => {
    const store = useSettingsStore()
    const wrapper = mount(SettingsView, {
      global: { plugins: [i18n] }
    })

    const frBtn = wrapper.findAll('button').find((b) => b.text() === 'Français')
    await frBtn?.trigger('click')

    expect(store.language).toBe('fr')
  })

  it('changes theme via buttons', async () => {
    const store = useSettingsStore()
    const wrapper = mount(SettingsView, {
      global: { plugins: [i18n] }
    })

    const darkBtn = wrapper.findAll('button').find((b) => b.text() === 'Dark')
    await darkBtn?.trigger('click')

    expect(store.theme).toBe('dark')
  })
})
