import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useSettingsStore } from '../../../src/stores/settingsStore'

describe('settingsStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with default settings', () => {
    const store = useSettingsStore()
    expect(store.settings.proof).toBe(true)
    expect(store.settings.days).toBe(30)
    expect(store.theme).toBe('system')
    expect(store.language).toBe('en')
  })

  it('toggles a boolean moderation setting', () => {
    const store = useSettingsStore()
    expect(store.settings.proof).toBe(true)
    store.toggleSetting('proof')
    expect(store.settings.proof).toBe(false)
  })

  it('updates retention days setting', () => {
    const store = useSettingsStore()
    store.setNumberSetting('days', 60)
    expect(store.settings.days).toBe(60)

    store.setNumberSetting('retain', 7)
    expect(store.settings.retain).toBe(7)
  })

  it('changes language', () => {
    const store = useSettingsStore()
    store.setLanguage('fr')
    expect(store.language).toBe('fr')
  })

  it('applies theme and modifies html data-theme attribute', () => {
    const store = useSettingsStore()
    store.applyTheme('dark')
    expect(store.theme).toBe('dark')
    expect(document.documentElement.getAttribute('data-theme')).toBe('dark')

    store.applyTheme('light')
    expect(store.theme).toBe('light')
    expect(document.documentElement.getAttribute('data-theme')).toBe('light')

    store.applyTheme('system')
    expect(store.theme).toBe('system')
    expect(document.documentElement.hasAttribute('data-theme')).toBe(false)
  })
})
