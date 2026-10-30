import { defineStore } from 'pinia'
import { ref, watch } from 'vue'
import type { ModerationSettings, AppTheme, AppLanguage } from '../types/models'
import { INITIAL_SETTINGS } from '../data/seed'
import { useAuditStore } from './auditStore'

export const useSettingsStore = defineStore('settings', () => {
  const auditStore = useAuditStore()
  const settings = ref<ModerationSettings>({ ...INITIAL_SETTINGS })
  const theme = ref<AppTheme>('system')
  const language = ref<AppLanguage>('en')

  function applyTheme(newTheme: AppTheme) {
    theme.value = newTheme
    if (typeof document !== 'undefined') {
      const root = document.documentElement
      if (newTheme === 'dark') {
        root.setAttribute('data-theme', 'dark')
      } else if (newTheme === 'light') {
        root.setAttribute('data-theme', 'light')
      } else {
        root.removeAttribute('data-theme')
      }
    }
  }

  function toggleSetting(key: keyof ModerationSettings) {
    if (typeof settings.value[key] === 'boolean') {
      ;(settings.value[key] as boolean) = !(settings.value[key] as boolean)
      auditStore.log(`changed moderation setting: ${key} to ${settings.value[key]}`)
    }
  }

  function setNumberSetting(key: 'days' | 'retain', value: number) {
    settings.value[key] = value
    auditStore.log(`changed retention setting: ${key} to ${value} days`)
  }

  function setLanguage(lang: AppLanguage) {
    language.value = lang
  }

  watch(theme, (newTheme) => {
    applyTheme(newTheme)
  }, { immediate: true })

  return {
    settings,
    theme,
    language,
    toggleSetting,
    setNumberSetting,
    applyTheme,
    setLanguage
  }
})
