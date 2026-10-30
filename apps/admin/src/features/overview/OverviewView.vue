<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSubmissionsStore } from '../../stores/submissionsStore'
import { useClaimsStore } from '../../stores/claimsStore'
import { useListingsStore } from '../../stores/listingsStore'
import { useAuditStore } from '../../stores/auditStore'
import AppButton from '../../components/common/AppButton.vue'

const router = useRouter()
const submissionsStore = useSubmissionsStore()
const claimsStore = useClaimsStore()
const listingsStore = useListingsStore()
const auditStore = useAuditStore()

const kpis = computed(() => [
  {
    label: 'Pending review',
    count: submissionsStore.queueCount,
    desc: 'Oldest waiting 3 days',
    isWarn: true
  },
  {
    label: 'Open claims',
    count: claimsStore.newClaimsCount,
    desc: '1 high-risk claim',
    isWarn: true
  },
  {
    label: 'Live listings',
    count: listingsStore.liveCount,
    desc: '+3 this week',
    isWarn: false
  },
  {
    label: 'Recovered this month',
    count: listingsStore.recoveredCount + 4,
    desc: 'Avg 3.2 days to return',
    isWarn: false
  }
])

const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
const submittedWeekly = [6, 9, 5, 11, 8, 4, 7]
const returnedWeekly = [3, 5, 4, 7, 6, 2, 4]
const maxWeekly = 12

const recentEvents = computed(() => auditStore.events.slice(0, 5))
</script>

<template>
  <div class="space-y-4">
    <!-- 4 KPI Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5">
      <div
        v-for="(kpi, i) in kpis"
        :key="kpi.label"
        class="bg-surf border border-line rounded-[18px] p-4.5 animate-in"
        :style="{ animationDelay: `${i * 70}ms` }"
      >
        <small class="text-mute font-medium text-xs">{{ kpi.label }}</small>
        <div class="font-display font-extrabold text-[34px] leading-tight mt-1 text-ink">
          {{ kpi.count }}
        </div>
        <div
          class="text-[12.5px] mt-0.5 font-semibold"
          :class="kpi.isWarn ? 'text-amb' : 'text-g'"
        >
          {{ kpi.desc }}
        </div>
      </div>
    </div>

    <!-- Charts & Activity Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-[1.6fr_1fr] gap-3.5">
      <!-- Weekly Chart -->
      <div class="bg-surf border border-line rounded-[18px] p-4.5">
        <h3 class="font-display font-bold text-lg text-ink">This week</h3>
        <div class="flex items-end gap-3.5 h-[190px] pt-3">
          <div
            v-for="(day, i) in daysOfWeek"
            :key="day"
            class="flex-1 flex flex-col items-center gap-1.5 h-full justify-end"
          >
            <div class="flex gap-1 items-end h-full w-full justify-center">
              <!-- Submitted bar (green) -->
              <i
                class="w-[38%] max-w-[22px] rounded-t-md bg-g animate-grow"
                :style="{
                  height: `${(submittedWeekly[i] / maxWeekly) * 100}%`,
                  animationDelay: `${i * 70}ms`
                }"
              />
              <!-- Returned bar (gold) -->
              <i
                class="w-[38%] max-w-[22px] rounded-t-md bg-sun animate-grow"
                :style="{
                  height: `${(returnedWeekly[i] / maxWeekly) * 100}%`,
                  animationDelay: `${i * 70 + 90}ms`
                }"
              />
            </div>
            <span class="text-xs text-mute">{{ day }}</span>
          </div>
        </div>

        <!-- Legend -->
        <div class="flex gap-4 text-[12.5px] text-mute mt-2 pt-2 border-t border-line/50">
          <span class="flex items-center gap-1.5">
            <i class="inline-block w-2.5 h-2.5 rounded-[3px] bg-g not-italic" />
            Found documents submitted
          </span>
          <span class="flex items-center gap-1.5">
            <i class="inline-block w-2.5 h-2.5 rounded-[3px] bg-sun not-italic" />
            Returned to owners
          </span>
        </div>
      </div>

      <!-- Recent Activity Feed -->
      <div class="bg-surf border border-line rounded-[18px] p-4.5 flex flex-col justify-between">
        <h3 class="font-display font-bold text-lg text-ink mb-2">Recent activity</h3>
        <div class="divide-y divide-line">
          <div
            v-for="(item, idx) in recentEvents"
            :key="idx"
            class="flex gap-3 py-2.5 text-[13.5px] text-ink items-start"
          >
            <i
              class="flex-none w-2.5 h-2.5 rounded-full mt-1.5 not-italic"
              :class="item.s === 1 ? 'bg-red' : 'bg-g'"
            />
            <div class="flex-1">
              <div>{{ item.w }}</div>
              <small class="block text-mute text-xs">{{ item.t }}</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Needs Attention Banner -->
    <div
      v-if="submissionsStore.queueCount > 0"
      class="bg-surf border border-line rounded-[18px] p-4.5 flex items-center justify-between gap-3.5 flex-wrap"
    >
      <div class="flex-1 min-w-[200px]">
        <h3 class="font-display font-bold text-lg text-ink">Needs attention</h3>
        <span class="text-mute text-sm">
          {{ submissionsStore.queueCount }} submissions are waiting for redaction and approval.
        </span>
      </div>
      <AppButton @click="router.push('/queue')">
        Open review queue
      </AppButton>
    </div>
  </div>
</template>
