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
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 md:gap-5 items-start">
    <!-- Moderation Card -->
    <div class="app-card p-5 sm:p-6 space-y-4">
      <div class="flex items-center gap-3 pb-3 border-b border-line/70">
        <div class="w-9 h-9 rounded-xl bg-g2 text-g flex items-center justify-center flex-none">
          <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <div>
          <h3 class="font-display font-bold text-base sm:text-lg text-ink">Moderation Policy</h3>
          <p class="text-xs text-mute">Validation checks required before documents are published</p>
        </div>
      </div>

      <div class="divide-y divide-line text-sm">
        <!-- Proof Question Toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div class="pr-2">
            <b class="text-ink">Require proof-of-ownership answer</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Claimants must answer a hidden-detail question</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.proof"
            label="Require proof-of-ownership answer"
            @change="settingsStore.toggleSetting('proof')"
          />
        </div>

        <!-- Phone Consent Toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div class="pr-2">
            <b class="text-ink">Require finder phone consent</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Needed strictly to arrange the handoff at collection hubs</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.phone"
            label="Require finder phone consent"
            @change="settingsStore.toggleSetting('phone')"
          />
        </div>

        <!-- SMS Notifications Toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div class="pr-2">
            <b class="text-ink">SMS claimants on status changes</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Automated handoff coordination and rejection alerts</small>
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
    <div class="app-card p-5 sm:p-6 space-y-4">
      <div class="flex items-center gap-3 pb-3 border-b border-line/70">
        <div class="w-9 h-9 rounded-xl bg-amb-tint text-amb flex items-center justify-center flex-none">
          <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
          </svg>
        </div>
        <div>
          <h3 class="font-display font-bold text-base sm:text-lg text-ink">Privacy (Law No. 2024/017)</h3>
          <p class="text-xs text-mute">Mandatory personal data protection and retention standards</p>
        </div>
      </div>

      <div class="divide-y divide-line text-sm">
        <!-- Log Views Toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div class="pr-2">
            <b class="text-ink">Log every original-photo view</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Mandatory audit logging; cannot be disabled in production</small>
          </div>
          <AppSwitch
            :model-value="settingsStore.settings.reveal"
            label="Log every original-photo view"
            @change="settingsStore.toggleSetting('reveal')"
          />
        </div>

        <!-- Auto-archive select -->
        <div class="flex items-center justify-between py-3 gap-3 flex-wrap sm:flex-nowrap">
          <div class="pr-2">
            <b class="text-ink">Auto-archive inactive listings</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Purge stale records from public directory</small>
          </div>
          <div class="relative w-36 flex-none">
            <select
              :value="settingsStore.settings.days"
              aria-label="Auto-archive inactive listings"
              class="appearance-none w-full bg-bg text-ink border border-line rounded-xl pl-3 pr-8 py-2 text-sm font-medium focus:border-g focus:bg-surf focus:outline-none cursor-pointer transition shadow-xs"
              @change="handleArchiveDaysChange"
            >
              <option :value="14">14 days</option>
              <option :value="30">30 days</option>
              <option :value="60">60 days</option>
            </select>
            <svg
              class="w-4 h-4 text-mute absolute right-2.5 top-3 pointer-events-none"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
            >
              <path d="m6 9 6 6 6-6" />
            </svg>
          </div>
        </div>

        <!-- Retention select -->
        <div class="flex items-center justify-between py-3 gap-3 flex-wrap sm:flex-nowrap">
          <div class="pr-2">
            <b class="text-ink">Delete original photos after recovery</b>
            <small class="block text-mute text-xs mt-0.5 leading-snug">Right to erasure under Law No. 2024/017</small>
          </div>
          <div class="relative w-36 flex-none">
            <select
              :value="settingsStore.settings.retain"
              aria-label="Delete original photos after recovery"
              class="appearance-none w-full bg-bg text-ink border border-line rounded-xl pl-3 pr-8 py-2 text-sm font-medium focus:border-g focus:bg-surf focus:outline-none cursor-pointer transition shadow-xs"
              @change="handleRetainDaysChange"
            >
              <option :value="7">7 days</option>
              <option :value="30">30 days</option>
              <option :value="90">90 days</option>
            </select>
            <svg
              class="w-4 h-4 text-mute absolute right-2.5 top-3 pointer-events-none"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
            >
              <path d="m6 9 6 6 6-6" />
            </svg>
          </div>
        </div>

        <!-- Language toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div>
            <b class="text-ink">Interface Language</b>
            <small class="block text-mute text-xs mt-0.5">Bilingual platform support</small>
          </div>
          <div class="flex gap-1.5 flex-none">
            <button
              type="button"
              class="px-3 py-1.5 rounded-xl text-xs font-bold cursor-pointer border transition shadow-xs"
              :class="settingsStore.language === 'en' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line hover:border-g'"
              @click="handleLanguageChange('en')"
            >
              English
            </button>
            <button
              type="button"
              class="px-3 py-1.5 rounded-xl text-xs font-bold cursor-pointer border transition shadow-xs"
              :class="settingsStore.language === 'fr' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line hover:border-g'"
              @click="handleLanguageChange('fr')"
            >
              Français
            </button>
          </div>
        </div>

        <!-- Theme toggle -->
        <div class="flex items-center justify-between py-3 gap-3">
          <div>
            <b class="text-ink">Theme</b>
            <small class="block text-mute text-xs mt-0.5">Display appearance</small>
          </div>
          <div class="flex gap-1.5 flex-none">
            <button
              type="button"
              class="px-2.5 py-1.5 rounded-xl text-xs font-bold cursor-pointer border transition shadow-xs"
              :class="settingsStore.theme === 'system' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line hover:border-g'"
              @click="handleThemeChange('system')"
            >
              System
            </button>
            <button
              type="button"
              class="px-2.5 py-1.5 rounded-xl text-xs font-bold cursor-pointer border transition shadow-xs"
              :class="settingsStore.theme === 'light' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line hover:border-g'"
              @click="handleThemeChange('light')"
            >
              Light
            </button>
            <button
              type="button"
              class="px-2.5 py-1.5 rounded-xl text-xs font-bold cursor-pointer border transition shadow-xs"
              :class="settingsStore.theme === 'dark' ? 'bg-g text-onG border-g' : 'bg-bg text-ink border-line hover:border-g'"
              @click="handleThemeChange('dark')"
            >
              Dark
            </button>
          </div>
        </div>
      </div>

      <!-- Legal Compliance Callout -->
      <div class="mt-4 p-3 rounded-xl bg-bg border border-line/80 flex items-start gap-2.5 text-xs text-mute leading-relaxed">
        <span class="text-base flex-none">🛡️</span>
        <span>
          <b class="text-ink">Cameroon Law No. 2024/017 compliance:</b> Admins have no default access to unredacted originals. Each reveal action is recorded with high sensitivity (<code class="bg-surface px-1 rounded text-red font-mono">s: 1</code>) in the tamper-evident audit log.
        </span>
      </div>
    </div>
  </div>
</template>
