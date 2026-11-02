<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/authStore'
import { useSettingsStore } from '../../stores/settingsStore'
import { useToast } from '../../composables/useToast'
import AppButton from '../../components/common/AppButton.vue'
import type { AppLanguage } from '../../types/models'
import { i18n } from '../../i18n'

const router = useRouter()
const authStore = useAuthStore()
const settingsStore = useSettingsStore()
const { showToast } = useToast()

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const rememberMe = ref(true)
const isLoading = ref(false)
const errorMessage = ref('')

function handleQuickFill() {
  email.value = 'admin@docfind.cm'
  password.value = 'admin1234'
  errorMessage.value = ''
  showToast('Demo credentials filled')
}

async function handleLogin() {
  errorMessage.value = ''
  const trimmedEmail = email.value.trim()
  const trimmedPass = password.value.trim()

  if (!trimmedEmail) {
    errorMessage.value = 'Please enter your administrator email address.'
    return
  }

  if (!trimmedPass) {
    errorMessage.value = 'Please enter your password.'
    return
  }

  isLoading.value = true

  // Short simulated authentication check
  await new Promise((resolve) => setTimeout(resolve, 400))

  const success = authStore.login(trimmedEmail, trimmedPass)
  isLoading.value = false

  if (success) {
    showToast(`Welcome back, ${authStore.user.name}!`)
    router.push('/')
  } else {
    errorMessage.value = 'Invalid administrator credentials. Try demo: admin@docfind.cm / admin1234'
  }
}

function toggleLanguage() {
  const nextLang: AppLanguage = settingsStore.language === 'en' ? 'fr' : 'en'
  settingsStore.setLanguage(nextLang)
  try {
    ;(i18n.global.locale as unknown as { value: string }).value = nextLang
  } catch {
    // fallback if i18n is mocked
  }
  showToast(nextLang === 'fr' ? 'Langue changée en Français' : 'Language changed to English')
}

function toggleTheme() {
  const nextTheme = settingsStore.theme === 'dark' ? 'light' : 'dark'
  settingsStore.applyTheme(nextTheme)
  showToast(`Theme: ${nextTheme}`)
}
</script>

<template>
  <div class="min-h-full w-full flex flex-col justify-between p-4 sm:p-6 md:p-8 bg-bg text-ink select-none">
    <!-- Top Header Navigation -->
    <header class="flex items-center justify-between max-w-5xl w-full mx-auto py-2">
      <div class="flex items-center gap-2.5">
        <svg viewBox="0 0 32 32" class="w-8 h-8 flex-none">
          <rect width="32" height="32" rx="9" fill="var(--g)" />
          <rect x="8" y="7" width="13" height="17" rx="2" fill="none" stroke="var(--onG)" stroke-width="2" />
          <circle cx="21" cy="21" r="5" fill="var(--sun)" stroke="var(--g)" stroke-width="2" />
        </svg>
        <div>
          <span class="font-display font-extrabold text-lg text-ink">Doc-Find</span>
          <span class="text-xs text-mute ml-1.5 font-medium hidden sm:inline">Admin Portal</span>
        </div>
      </div>

      <!-- Quick Toggles -->
      <div class="flex items-center gap-2">
        <button
          type="button"
          class="px-2.5 py-1 rounded-lg text-xs font-bold border border-line hover:border-g text-ink bg-surf transition cursor-pointer shadow-xs"
          @click="toggleLanguage"
        >
          {{ settingsStore.language.toUpperCase() }}
        </button>

        <button
          type="button"
          class="p-1.5 rounded-lg border border-line hover:border-g text-mute hover:text-ink bg-surf transition cursor-pointer shadow-xs flex items-center justify-center"
          :title="settingsStore.theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'"
          @click="toggleTheme"
        >
          <svg
            v-if="settingsStore.theme === 'dark'"
            class="w-4 h-4 text-sun"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <circle cx="12" cy="12" r="5" />
            <line x1="12" y1="1" x2="12" y2="3" />
            <line x1="12" y1="21" x2="12" y2="23" />
            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
            <line x1="1" y1="12" x2="3" y2="12" />
            <line x1="21" y1="12" x2="23" y2="12" />
            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" />
            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
          </svg>
          <svg
            v-else
            class="w-4 h-4 text-mute"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
          </svg>
        </button>
      </div>
    </header>

    <!-- Main Login Card Container -->
    <main class="w-full max-w-[440px] mx-auto my-auto py-8">
      <div class="app-card p-6 sm:p-8 space-y-6 shadow-md">
        <!-- Logo & Header Text -->
        <div class="text-center space-y-2">
          <div class="w-12 h-12 rounded-2xl bg-g2 text-g mx-auto flex items-center justify-center">
            <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg>
          </div>
          <h2 class="font-display font-extrabold text-2xl text-ink">
            Admin Sign In
          </h2>
          <p class="text-xs text-mute">
            Official moderation & verification console for Cameroon lost documents
          </p>
        </div>

        <!-- Error Alert Banner -->
        <div
          v-if="errorMessage"
          class="p-3 rounded-xl bg-red-tint text-red border border-red/20 text-xs flex items-center gap-2 animate-in"
        >
          <svg class="w-4 h-4 flex-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10" />
            <line x1="12" y1="8" x2="12" y2="12" />
            <line x1="12" y1="16" x2="12.01" y2="16" />
          </svg>
          <span>{{ errorMessage }}</span>
        </div>

        <!-- Login Form -->
        <form class="space-y-4" @submit.prevent="handleLogin">
          <!-- Email Input -->
          <div class="space-y-1.5">
            <label class="block text-xs font-semibold text-ink" for="admin-email">
              Workstation Email
            </label>
            <div class="relative">
              <input
                id="admin-email"
                v-model="email"
                type="email"
                required
                autocomplete="email"
                placeholder="admin@docfind.cm"
                class="w-full bg-bg border border-line rounded-xl pl-9 pr-3.5 py-2.5 text-sm text-ink transition focus:border-g focus:bg-surf focus:outline-none"
              />
              <svg
                class="w-4 h-4 text-mute absolute left-3 top-3 pointer-events-none"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                <polyline points="22,6 12,13 2,6" />
              </svg>
            </div>
          </div>

          <!-- Password Input -->
          <div class="space-y-1.5">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-ink" for="admin-password">
                Password
              </label>
            </div>
            <div class="relative">
              <input
                id="admin-password"
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                required
                autocomplete="current-password"
                placeholder="••••••••"
                class="w-full bg-bg border border-line rounded-xl pl-9 pr-10 py-2.5 text-sm text-ink transition focus:border-g focus:bg-surf focus:outline-none"
              />
              <svg
                class="w-4 h-4 text-mute absolute left-3 top-3 pointer-events-none"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <!-- Show/Hide Password Button -->
              <button
                type="button"
                class="absolute right-3 top-2.5 text-mute hover:text-ink cursor-pointer p-0.5"
                :title="showPassword ? 'Hide password' : 'Show password'"
                @click="showPassword = !showPassword"
              >
                <svg v-if="!showPassword" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                  <circle cx="12" cy="12" r="3" />
                </svg>
                <svg v-else class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                  <line x1="1" y1="1" x2="23" y2="23" />
                </svg>
              </button>
            </div>
          </div>

          <!-- Remember Me Checkbox -->
          <div class="flex items-center justify-between text-xs pt-1">
            <label class="flex items-center gap-2 cursor-pointer text-mute hover:text-ink">
              <input
                v-model="rememberMe"
                type="checkbox"
                class="rounded border-line text-g focus:ring-g accent-g"
              />
              <span>Remember this session</span>
            </label>
            <span class="text-mute hover:text-g cursor-pointer" @click="handleQuickFill">
              Fill demo credentials
            </span>
          </div>

          <!-- Submit Button -->
          <AppButton
            type="submit"
            variant="primary"
            class="w-full justify-center py-2.5 mt-2"
            :disabled="isLoading"
          >
            <template v-if="isLoading">
              <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white inline-block" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
              </svg>
              Authenticating...
            </template>
            <template v-else>
              Sign in to Admin Console
            </template>
          </AppButton>
        </form>

        <!-- Quick Demo Fill Button -->
        <button
          type="button"
          class="w-full text-center text-xs text-g font-semibold py-2 px-3 rounded-xl border border-g/30 bg-g2/40 hover:bg-g2 transition cursor-pointer flex items-center justify-center gap-1.5"
          @click="handleQuickFill"
        >
          <span>⚡</span>
          <span>Click to Auto-fill Demo Moderator</span>
        </button>

        <!-- Security & Legal Notice -->
        <div class="pt-3 border-t border-line/60 text-center">
          <div class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-g2 text-g text-[11px] font-semibold mb-2">
            <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg>
            Law No. 2024/017 Enforced
          </div>
          <p class="text-[11px] text-mute leading-relaxed">
            All moderator actions, proof verification, and unredacted document reviews are cryptographically recorded in tamper-evident audit logs.
          </p>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="text-center py-3 text-xs text-mute max-w-5xl w-full mx-auto">
      Republic of Cameroon · National Official Documents Lost & Found Infrastructure
    </footer>
  </div>
</template>
