<script setup lang="ts">
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSubmissionsStore } from '../../stores/submissionsStore'
import { useClaimsStore } from '../../stores/claimsStore'
import { useFraudStore } from '../../stores/fraudStore'
import { useAuthStore } from '../../stores/authStore'

const router = useRouter()
const route = useRoute()

const submissionsStore = useSubmissionsStore()
const claimsStore = useClaimsStore()
const fraudStore = useFraudStore()
const authStore = useAuthStore()

interface NavItem {
  key: string
  path: string
  label: string
  badge?: number
  svgPath: string
}

const navItems = computed<NavItem[]>(() => [
  {
    key: 'overview',
    path: '/',
    label: 'Overview',
    svgPath:
      '<rect x="3" y="3" width="7" height="9"/><rect x="14" y="3" width="7" height="5"/><rect x="14" y="12" width="7" height="9"/><rect x="3" y="16" width="7" height="5"/>'
  },
  {
    key: 'queue',
    path: '/queue',
    label: 'Review queue',
    badge: submissionsStore.queueCount,
    svgPath: '<path d="M4 6h16M4 12h16M4 18h10"/>'
  },
  {
    key: 'claims',
    path: '/claims',
    label: 'Claims',
    badge: claimsStore.newClaimsCount,
    svgPath: '<path d="M4 5h16v11H9l-5 4z"/>'
  },
  {
    key: 'listings',
    path: '/listings',
    label: 'Listings',
    svgPath:
      '<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/>'
  },
  {
    key: 'fraud',
    path: '/fraud',
    label: 'Fraud reports',
    badge: fraudStore.openCount,
    svgPath: '<path d="M12 3l9 16H3z"/><path d="M12 10v4M12 17h.01"/>'
  },
  {
    key: 'audit',
    path: '/audit',
    label: 'Audit log',
    svgPath: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>'
  },
  {
    key: 'settings',
    path: '/settings',
    label: 'Settings',
    svgPath:
      '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M5 5l2 2M17 17l2 2M19 5l-2 2M7 17l-2 2"/>'
  }
])

function isActive(path: string) {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}

function navigate(path: string) {
  router.push(path)
}

function handleLogout() {
  authStore.logout()
  router.push('/login')
}
</script>

<template>
  <aside
    class="bg-side text-[#E8F0EB] flex flex-col p-4 md:py-[18px] md:px-3 gap-1 overflow-auto max-md:flex-row max-md:p-1.5 max-md:pb-[calc(env(safe-area-inset-bottom,0px)+6px)] max-md:justify-around max-md:overflow-x-auto no-scrollbar max-md:gap-0 max-md:z-30 select-none flex-none"
  >
    <!-- Brand (Desktop only) -->
    <div class="hidden md:flex items-center gap-2.5 px-2.5 pt-1 pb-4 font-display font-extrabold text-[20px] text-white">
      <svg viewBox="0 0 32 32" class="w-8 h-8 flex-none">
        <rect width="32" height="32" rx="9" fill="var(--g)" />
        <rect x="8" y="7" width="13" height="17" rx="2" fill="none" stroke="var(--onG)" stroke-width="2" />
        <circle cx="21" cy="21" r="5" fill="var(--sun)" stroke="var(--g)" stroke-width="2" />
      </svg>
      <div>
        Doc-Find
        <small class="block font-sans font-medium text-[11px] opacity-60 -mt-0.5">Admin console</small>
      </div>
    </div>

    <!-- Nav items -->
    <div class="flex flex-col gap-1 w-full max-md:flex-row max-md:justify-around max-md:gap-0">
      <button
        v-for="item in navItems"
        :key="item.key"
        type="button"
        class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-medium text-left transition relative cursor-pointer max-md:flex-col max-md:gap-0.5 max-md:py-1.5 max-md:px-2 max-md:text-[10.5px] max-md:min-w-[56px] max-md:flex-1"
        :class="[
          isActive(item.path)
            ? 'bg-g text-onG shadow-sm'
            : 'text-[#B9CBC1] hover:bg-white/10 hover:text-white'
        ]"
        @click="navigate(item.path)"
      >
        <svg
          viewBox="0 0 24 24"
          class="w-5 h-5 flex-none fill-none stroke-current stroke-[1.8] stroke-linecap-round stroke-linejoin-round"
          v-html="item.svgPath"
        />
        <span>{{ item.label }}</span>
        <b
          v-if="item.badge && item.badge > 0"
          class="ml-auto bg-sun text-[#111] rounded-full text-[11px] px-1.5 min-w-[20px] text-center font-bold max-md:absolute max-md:top-0 max-md:right-1.5 max-md:m-0"
        >
          {{ item.badge }}
        </b>
      </button>
    </div>

    <!-- User Profile (Desktop only) -->
    <div class="hidden md:flex mt-auto gap-2.5 items-center p-3 border-t border-white/15 text-[13px] justify-between">
      <div class="flex items-center gap-2.5 min-w-0">
        <div class="flex-none w-9 h-9 rounded-full bg-sun text-[#111] grid place-items-center font-extrabold text-sm">
          {{ authStore.user.initials }}
        </div>
        <div class="min-w-0">
          <div class="font-bold text-white leading-tight truncate">{{ authStore.user.name }}</div>
          <small class="opacity-60 text-xs block truncate">{{ authStore.user.role }} · {{ authStore.user.location }}</small>
        </div>
      </div>
      <button
        type="button"
        class="p-1.5 rounded-lg text-[#B9CBC1] hover:text-white hover:bg-white/10 transition cursor-pointer flex-none"
        title="Sign out"
        aria-label="Sign out"
        @click="handleLogout"
      >
        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
          <polyline points="16 17 21 12 16 7" />
          <line x1="21" y1="12" x2="9" y2="12" />
        </svg>
      </button>
    </div>
  </aside>
</template>
