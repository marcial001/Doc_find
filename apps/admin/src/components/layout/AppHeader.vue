<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useListingsStore } from '../../stores/listingsStore'

const route = useRoute()
const router = useRouter()
const listingsStore = useListingsStore()

const searchInput = ref('')

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
}
</script>

<template>
  <header
    class="flex items-center gap-3.5 px-6 py-3.5 bg-surf border-b border-line max-md:px-4 max-md:py-3"
  >
    <h1 class="text-[22px] font-bold font-display text-ink flex-none max-md:text-[19px]">
      {{ title }}
    </h1>

    <div class="flex-1 max-w-[420px] ml-auto hidden md:block">
      <input
        v-model="searchInput"
        type="search"
        placeholder="Search listings and press Enter"
        aria-label="Search"
        class="w-full bg-bg border-[1.5px] border-transparent rounded-xl px-3.5 py-2 text-ink text-sm transition focus:border-g focus:outline-none"
        @keydown.enter="handleSearch"
      />
    </div>
  </header>
</template>
