<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useListingsStore } from '../../stores/listingsStore'
import { useSettingsStore } from '../../stores/settingsStore'
import { useAuthStore } from '../../stores/authStore'
import { useToast } from '../../composables/useToast'
import type { AppLanguage } from '../../types/models'

import { i18n } from '../../i18n'

const route = useRoute()
const router = useRouter()
const listingsStore = useListingsStore()
const settingsStore = useSettingsStore()
const authStore = useAuthStore()
const { showToast } = useToast()

const searchInput = ref('')
const mobileSearchOpen = ref(false)

const title = computed(() => {
  return (route.meta?.title as string) || 'Doc-Find Admin'
})

function handleSearch() {
  const query = searchInput.value.trim()
  listingsStore.setSearchQuery(query)
  listingsStore.setStatusFilter('All')
  if (route.path !== '/listings') {
    router.push('/listings')
  }
  mobileSearchOpen.value = false
}

function toggleLanguage() {
  const nextLang: AppLanguage = settingsStore.language === 'en' ? 'fr' : 'en'
  settingsStore.setLanguage(nextLang)
  try {
    ;(i18n.global.locale as unknown as { value: string }).value = nextLang
  } catch {
    // fallback if i18n instance is mocked
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
  <header
    class="flex items-center justify-between gap-3 px-4 sm:px-6 py-3 md:py-3.5 bg-surf border-b border-line select-none flex-none transition-colors"
  >
    <!-- View Title & Law 2024/017 Pill -->
    <div class="flex items-center gap-2.5 min-w-0">
      <h1 class="text-lg sm:text-[22px] font-bold font-display text-ink truncate">
        {{ title }}
      </h1>
      <span
        class="hidden sm:inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-g2 text-g border border-g/20 whitespace-nowrap"
        title="Cameroon Law No. 2024/017 on Personal Data Protection compliant"
      >
        <svg class="w-3 h-3 text-g" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        </svg>
        Law 2024/017
      </span>
    </div>

    <!-- Center/Right Controls: Search Bar & Actions -->
    <div class="flex items-center gap-2 sm:gap-3 ml-auto">
      <!-- Desktop Search Bar -->
      <div class="relative w-48 sm:w-64 md:w-80 hidden md:block">
        <input
          v-model="searchInput"
          type="search"
          placeholder="Search listings and press Enter"
          aria-label="Search"
          class="w-full bg-bg border border-line/70 rounded-xl pl-9 pr-3 py-1.5 text-ink text-sm transition focus:border-g focus:bg-surf focus:outline-none"
          @keydown.enter="handleSearch"
        />
        <svg
          class="w-4 h-4 text-mute absolute left-3 top-2.5 pointer-events-none"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
        >
          <circle cx="11" cy="11" r="8" />
          <path d="m21 21-4.35-4.35" />
        </svg>
      </div>

      <!-- Mobile Search Toggle Button -->
      <button
        type="button"
        class="md:hidden p-2 rounded-xl text-mute hover:text-ink hover:bg-bg cursor-pointer transition"
        aria-label="Toggle mobile search"
        @click="mobileSearchOpen = !mobileSearchOpen"
      >
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8" />
          <path d="m21 21-4.35-4.35" />
        </svg>
      </button>

      <!-- Quick Language Toggle (EN/FR) -->
      <button
        type="button"
        class="px-2.5 py-1 rounded-lg text-xs font-bold border border-line hover:border-g text-ink bg-bg hover:bg-surf transition cursor-pointer"
        :title="settingsStore.language === 'en' ? 'Switch to Français' : 'Passer à l\'anglais'"
        @click="toggleLanguage"
      >
        {{ settingsStore.language.toUpperCase() }}
      </button>

      <!-- Quick Theme Toggle (Light / Dark) -->
      <button
        type="button"
        class="p-1.5 rounded-lg border border-line hover:border-g text-mute hover:text-ink bg-bg hover:bg-surf transition cursor-pointer flex items-center justify-center"
        :title="settingsStore.theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'"
        @click="toggleTheme"
      >
        <!-- Sun icon (shown when dark) -->
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
        <!-- Moon icon (shown when light/system) -->
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

      <!-- Mobile User Initials Avatar -->
      <div
        class="md:hidden flex-none w-7 h-7 rounded-full bg-sun text-[#111] grid place-items-center font-extrabold text-xs"
        :title="authStore.user.name"
      >
        {{ authStore.user.initials }}
      </div>
    </div>
  </header>

  <!-- Mobile Collapsible Search Dropdown -->
  <div
    v-if="mobileSearchOpen"
    class="md:hidden px-4 py-2.5 bg-surf border-b border-line animate-in"
  >
    <div class="relative w-full">
      <input
        v-model="searchInput"
        type="search"
        placeholder="Search listings and press Enter"
        aria-label="Search"
        class="w-full bg-bg border border-line rounded-xl pl-9 pr-3 py-2 text-ink text-sm focus:border-g focus:outline-none"
        autofocus
        @keydown.enter="handleSearch"
      />
      <svg
        class="w-4 h-4 text-mute absolute left-3 top-3 pointer-events-none"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
      >
        <circle cx="11" cy="11" r="8" />
        <path d="m21 21-4.35-4.35" />
      </svg>
    </div>
  </div>
</template>
