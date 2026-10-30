<script setup lang="ts">
import { useFraudStore } from '../../stores/fraudStore'
import { useToast } from '../../composables/useToast'
import AppButton from '../../components/common/AppButton.vue'
import AppPill from '../../components/common/AppPill.vue'

const fraudStore = useFraudStore()
const { showToast } = useToast()

function handleSuspend(id: number) {
  fraudStore.suspendUser(id)
  showToast('User suspended')
}

function handleDismiss(id: number) {
  fraudStore.dismissReport(id)
  showToast('Report dismissed')
}
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
    <div
      v-for="(f, i) in fraudStore.reports"
      :key="f.id"
      class="bg-surf border border-line rounded-[18px] p-4.5 flex flex-col justify-between animate-in"
      :style="{ animationDelay: `${i * 70}ms` }"
    >
      <div>
        <div class="flex items-center justify-between mb-2">
          <b class="text-ink font-bold text-sm">{{ f.who }}</b>
          <AppPill
            :variant="f.sev === 'High' ? 'r' : f.sev === 'Medium' ? 'w' : 'm'"
          >
            {{ f.sev }}
          </AppPill>
        </div>

        <p class="text-mute text-sm my-2 leading-relaxed">
          {{ f.why }}
        </p>

        <small class="text-mute text-xs block mb-3">
          Source: {{ f.by }}
        </small>
      </div>

      <!-- Action buttons / status pill -->
      <div class="flex gap-2 items-center pt-2 border-t border-line/60">
        <template v-if="f.st === 'open'">
          <AppButton
            variant="red"
            size="sm"
            @click="handleSuspend(f.id)"
          >
            Suspend user
          </AppButton>
          <AppButton
            variant="alt"
            size="sm"
            @click="handleDismiss(f.id)"
          >
            Dismiss
          </AppButton>
        </template>
        <template v-else>
          <AppPill :variant="f.st === 'Suspended' ? 'r' : 'm'">
            {{ f.st }}
          </AppPill>
        </template>
      </div>
    </div>
  </div>
</template>
