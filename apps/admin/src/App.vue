<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AppSidebar from './components/layout/AppSidebar.vue'
import AppHeader from './components/layout/AppHeader.vue'
import AppToast from './components/common/AppToast.vue'
import AppSheet from './components/common/AppSheet.vue'

const route = useRoute()
const isAuthPage = computed(() => route.path === '/login')
</script>

<template>
  <div class="relative w-full h-full overflow-hidden bg-bg text-ink flex flex-col">
    <!-- Login / Auth View: Fullscreen -->
    <template v-if="isAuthPage">
      <main class="w-full h-full overflow-y-auto">
        <router-view />
      </main>
    </template>

    <!-- Admin Shell: Sidebar + Header + Content Grid -->
    <template v-else>
      <div class="grid grid-cols-1 md:grid-cols-[232px_1fr] max-md:grid-rows-[1fr_auto] h-full w-full overflow-hidden">
        <!-- Sidebar / Bottom Bar -->
        <AppSidebar class="max-md:order-2" />

        <!-- Main Content Area -->
        <div class="flex flex-col min-w-0 h-full overflow-hidden max-md:order-1">
          <AppHeader />
          <main class="flex-1 overflow-y-auto p-4 sm:p-5 md:p-6 pb-20 md:pb-10">
            <div class="w-full max-w-[1440px] mx-auto">
              <router-view />
            </div>
          </main>
        </div>
      </div>
    </template>

    <!-- Global Floating Toast & Modal Sheets (Isolated from layout grid) -->
    <AppToast />
    <AppSheet />
  </div>
</template>
