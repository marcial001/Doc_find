<script setup lang="ts">
import { useAuditStore } from '../../stores/auditStore'
import AppButton from '../../components/common/AppButton.vue'
import AppPill from '../../components/common/AppPill.vue'

const auditStore = useAuditStore()
</script>

<template>
  <div class="bg-surf border border-line rounded-[18px] p-4.5 space-y-3.5">
    <!-- Header with Toggle Button -->
    <div class="flex items-center justify-between gap-3 flex-wrap">
      <span class="text-mute text-sm">
        Every admin action is recorded. Opening an original document photo is flagged.
      </span>
      <AppButton
        variant="alt"
        size="sm"
        @click="auditStore.toggleSensitiveFilter"
      >
        {{ auditStore.showSensitiveOnly ? 'Show all' : 'Show sensitive only' }}
      </AppButton>
    </div>

    <!-- Audit Events Table -->
    <div class="overflow-x-auto">
      <table class="w-full border-collapse text-[13.5px]">
        <thead>
          <tr class="border-b border-line text-xs font-semibold text-mute text-left">
            <th class="py-2.5 px-3 whitespace-nowrap w-28">When</th>
            <th class="py-2.5 px-3">Event</th>
            <th class="py-2.5 px-3 text-right w-24"></th>
          </tr>
        </thead>
        <tbody class="divide-y divide-line">
          <tr
            v-for="(x, i) in auditStore.filteredEvents"
            :key="i"
            class="animate-in hover:bg-bg/40 transition-colors"
            :style="{ animationDelay: `${i * 30}ms` }"
          >
            <td class="py-3 px-3 text-mute whitespace-nowrap">
              {{ x.t }}
            </td>
            <td class="py-3 px-3 text-ink">
              {{ x.w }}
            </td>
            <td class="py-3 px-3 text-right">
              <AppPill v-if="x.s === 1" variant="r">
                Sensitive
              </AppPill>
            </td>
          </tr>
          <tr v-if="auditStore.filteredEvents.length === 0">
            <td colspan="3" class="py-12 text-center text-mute">
              No audit events found.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
