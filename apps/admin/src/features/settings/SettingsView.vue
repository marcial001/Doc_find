<script setup lang="ts">
import { useSettingsStore } from '../../stores/settingsStore'
import { useToast } from '../../composables/useToast'
import { useI18n } from 'vue-i18n'
import type { AppLanguage, AppTheme } from '../../types/models'
import AppSwitch from '../../components/common/AppSwitch.vue'

const settingsStore = useSettingsStore()
const { showToast } = useToast()
const { locale } = useI18n()

function handleArchiveDaysChange(event: Event) {
  const target = event.target as HTMLSelectElement
  const val = Number(target.value)
  settingsStore.setNumberSetting('days', val)
  showToast('Saved')
}

function handleRetainDaysChange(event: Event) {
  const target = event.target as HTMLSelectElement
  const val = Number(target.value)
  settingsStore.setNumberSetting('retain', val)
  showToast('Saved')
}

function handleLanguageChange(lang: AppLanguage) {
  settingsStore.setLanguage(lang)
  locale.value = lang
  showToast(lang === 'fr' ? 'Langue changée en Français' : 'Language changed to English')
}

function handleThemeChange(theme: AppTheme) {
  settingsStore.applyTheme(theme)
  showToast(`Theme changed to ${theme}`)
}
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-3.5 items-start">
    <!-- Moderation Card -->
    <div class="bg-surf border border-line rounded-[18px] p-4.5 space-y-4">
      <h3 class="font-display font-bold text-lg text-ink">Moderation</h3>

      <div class="divide-y divide-line text-sm">
        <!-- Proof Question Toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Require proof-of-ownership answer</b>
            <small class="block text-mute">Claimants must answer a hidden-detail question</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.proof"
            label="Require proof-of-ownership answer"
            @change="settingsStore.toggleSetting('proof')"
          />
        </div>

        <!-- Phone Consent Toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Require finder phone consent</b>
            <small class="block text-mute">Needed to arrange the handoff</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.phone"
            label="Require finder phone consent"
            @change="settingsStore.toggleSetting('phone')"
          />
        </div>

        <!-- SMS Notifications Toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>SMS claimants on status changes</b>
            <small class="block text-mute">Handoff and rejection messages</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.sms"
            label="SMS claimants on status changes"
            @change="settingsStore.toggleSetting('sms')"
          />
        </div>
      </div>
    </div>

    <!-- Privacy (Law No. 2024/017) & System Card -->
    <div class="bg-surf border border-line rounded-[18px] p-4.5 space-y-4">
      <h3 class="font-display font-bold text-lg text-ink">Privacy (Law No. 2024/017)</h3>

      <div class="divide-y divide-line text-sm">
        <!-- Log Views Toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Log every original-photo view</b>
            <small class="block text-mute">Strongly recommended, cannot be disabled in production</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.reveal"
            label="Log every original-photo view"
            @change="settingsStore.toggleSetting('reveal')"
          />
        </div>

        <!-- Auto-archive select -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Auto-archive inactive listings</b>
          </div>
          <select
            :value="settingsStore.settings.days"
            class="bg-bg text-ink border-[1.5px] border-line rounded-xl px-3 py-1.5 text-sm focus:border-g focus:outline-none w-32"
            @change="handleArchiveDaysChange"
          >
            <option :value="14">14 days</option>
            <option :value="30">30 days</option>
            <option :value="60">60 days</option>
          </select>
        </div>

        <!-- Retention select -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Delete original photos after recovery</b>
          </div>
          <select
            :value="settingsStore.settings.retain"
            class="bg-bg text-ink border-[1.5px] border-line rounded-xl px-3 py-1.5 text-sm focus:border-g focus:outline-none w-32"
            @change="handleRetainDaysChange"
          >
            <option :value="7">7 days</option>
            <option :value="30">30 days</option>
            <option :value="90">90 days</option>
          </select>
        </div>

        <!-- Language toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Interface Language</b>
          </div>
          <div class="flex gap-1.5">
            <button
              type="button"
              class="px-3 py-1 rounded-lg text-xs font-semibold cursor-pointer border"
              :class="settingsStore.language === 'en' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line'"
              @click="handleLanguageChange('en')"
            >
              English
            </button>
            <button
              type="button"
              class="px-3 py-1 rounded-lg text-xs font-semibold cursor-pointer border"
              :class="settingsStore.language === 'fr' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line'"
              @click="handleLanguageChange('fr')"
            >
              Français
            </button>
          </div>
        </div>

        <!-- Theme toggle -->
        <div class="flex items-center justify-between py-2.5">
          <div>
            <b>Theme</b>
          </div>
          <div class="flex gap-1.5">
            <button
              type="button"
              class="px-2.5 py-1 rounded-lg text-xs font-semibold cursor-pointer border"
              :class="settingsStore.theme === 'system' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line'"
              @click="handleThemeChange('system')"
            >
              System
            </button>
            <button
              type="button"
              class="px-2.5 py-1 rounded-lg text-xs font-semibold cursor-pointer border"
              :class="settingsStore.theme === 'light' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line'"
              @click="handleThemeChange('light')"
            >
              Light
            </button>
            <button
              type="button"
              class="px-2.5 py-1 rounded-lg text-xs font-semibold cursor-pointer border"
              :class="settingsStore.theme === 'dark' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line'"
              @click="handleThemeChange('dark')"
            >
              Dark
            </button>
          </div>
        </div>
      </div>

      <p class="text-mute text-xs pt-2">
        Admins have no default access to originals. Each view needs a click and is written to the audit log.
      </p>
    </div>
  </div>
</template>
