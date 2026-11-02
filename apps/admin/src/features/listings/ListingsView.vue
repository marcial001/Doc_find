<script setup lang="ts">
import { useListingsStore } from '../../stores/listingsStore'
import { useSettingsStore } from '../../stores/settingsStore'
import { useModalSheet } from '../../composables/useModalSheet'
import { useToast } from '../../composables/useToast'
import { DOCUMENT_TYPE_LABELS } from '../../data/seed'
import type { ListingStatus } from '../../types/models'
import AppButton from '../../components/common/AppButton.vue'
import AppPill from '../../components/common/AppPill.vue'
import AppChip from '../../components/common/AppChip.vue'

const listingsStore = useListingsStore()
const settingsStore = useSettingsStore()
const { openSheet } = useModalSheet()
const { showToast } = useToast()

const filterOptions: Array<'All' | ListingStatus> = ['All', 'Live', 'Recovered', 'Archived']

function handleStatusChange(id: number, newStatus: ListingStatus) {
  listingsStore.updateListingStatus(id, newStatus)
  showToast(`Listing ${newStatus.toLowerCase()}`)
}

function handleOpenBulk() {
  openSheet('bulk')
}
</script>

<template>
  <div class="space-y-3.5">
    <!-- Auto-Archive Notice Banner -->
    <div class="flex items-center gap-2.5 bg-amb-tint text-amb rounded-2xl p-3 px-4 text-[13.5px]">
      <span class="text-base">⏱️</span>
      <span>
        Listings with no activity for <b>{{ settingsStore.settings.days }} days</b> are archived automatically. Change this in Settings.
      </span>
    </div>

    <!-- Filter Bar and Table Card -->
    <div class="app-card p-4.5">
      <!-- Toolbar Controls -->
      <div class="flex gap-2.5 flex-wrap items-center justify-between mb-3.5">
        <!-- Status Filter Chips -->
        <div class="flex gap-1.5 flex-wrap">
          <AppChip
            v-for="f in filterOptions"
            :key="f"
            :active="listingsStore.statusFilter === f"
            @click="listingsStore.setStatusFilter(f)"
          >
            {{ f }}
          </AppChip>
        </div>

        <!-- Search Input & Bulk CSV Button -->
        <div class="flex gap-2 items-center flex-wrap ml-auto">
          <input
            v-model="listingsStore.searchQuery"
            type="search"
            placeholder="Filter by type or town"
            aria-label="Filter"
            class="bg-bg text-ink border-[1.5px] border-transparent rounded-xl px-3 py-1.5 text-sm focus:border-g focus:outline-none w-56"
          />
          <AppButton size="sm" @click="handleOpenBulk">
            Bulk post (CSV)
          </AppButton>
        </div>
      </div>

      <!-- Data Table -->
      <div class="overflow-x-auto">
        <table class="w-full border-collapse text-[13.5px]">
          <thead>
            <tr class="border-b border-line text-xs font-semibold text-mute text-left">
              <th class="py-2.5 px-3 whitespace-nowrap">Document</th>
              <th class="py-2.5 px-3 whitespace-nowrap">Town</th>
              <th class="py-2.5 px-3 whitespace-nowrap">Online</th>
              <th class="py-2.5 px-3 whitespace-nowrap">Status</th>
              <th class="py-2.5 px-3 whitespace-nowrap">Views</th>
              <th class="py-2.5 px-3 whitespace-nowrap">Claims</th>
              <th class="py-2.5 px-3 text-right whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-line">
            <tr
              v-for="(l, i) in listingsStore.filteredListings"
              :key="l.id"
              class="animate-in hover:bg-bg/40 transition-colors"
              :style="{ animationDelay: `${i * 30}ms` }"
            >
              <td class="py-3 px-3 font-semibold text-ink">
                {{ DOCUMENT_TYPE_LABELS[l.type] }}
              </td>
              <td class="py-3 px-3 text-ink">
                {{ l.town }}
              </td>
              <td class="py-3 px-3 text-ink">
                {{ l.days ? `${l.days} d` : 'Today' }}
              </td>
              <td class="py-3 px-3">
                <AppPill
                  :variant="l.st === 'Live' ? 'default' : l.st === 'Recovered' ? 'm' : 'w'"
                >
                  {{ l.st }}
                </AppPill>
              </td>
              <td class="py-3 px-3 text-ink">
                {{ l.views }}
              </td>
              <td class="py-3 px-3 text-ink">
                {{ l.cl }}
              </td>
              <td class="py-3 px-3 text-right whitespace-nowrap space-x-1.5">
                <template v-if="l.st === 'Live'">
                  <AppButton
                    variant="alt"
                    size="sm"
                    @click="handleStatusChange(l.id, 'Recovered')"
                  >
                    Mark recovered
                  </AppButton>
                  <AppButton
                    variant="red"
                    size="sm"
                    @click="handleStatusChange(l.id, 'Archived')"
                  >
                    Archive
                  </AppButton>
                </template>
                <template v-else>
                  <AppButton
                    variant="alt"
                    size="sm"
                    @click="handleStatusChange(l.id, 'Live')"
                  >
                    Restore
                  </AppButton>
                </template>
              </td>
            </tr>
            <tr v-if="listingsStore.filteredListings.length === 0">
              <td colspan="7" class="py-12 text-center text-mute">
                No listings match.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
