<script setup lang="ts">
import { ref } from 'vue'
import { useModalSheet } from '../../composables/useModalSheet'
import { useSubmissionsStore } from '../../stores/submissionsStore'
import { useClaimsStore } from '../../stores/claimsStore'
import { useToast } from '../../composables/useToast'
import {
  HANDOFF_PICKUP_POINTS,
  HANDOFF_TIME_SLOTS,
  PARTNER_INSTITUTIONS,
  REJECT_SUBMISSION_REASONS
} from '../../data/cameroon'
import AppButton from './AppButton.vue'

const { isOpen, activeType, sheetPayload, closeSheet } = useModalSheet()
const submissionsStore = useSubmissionsStore()
const claimsStore = useClaimsStore()
const { showToast } = useToast()

// Reject Sheet State
const selectedRejectReason = ref(REJECT_SUBMISSION_REASONS[0])

// Handoff Sheet State
const selectedPickupPoint = ref(HANDOFF_PICKUP_POINTS[0])
const selectedTimeSlot = ref(HANDOFF_TIME_SLOTS[0])

// Bulk Upload State
const selectedPartner = ref(PARTNER_INSTITUTIONS[0])
const isUploading = ref(false)
const uploadProgress = ref(0)

function handleRejectConfirm() {
  if (sheetPayload.value?.id) {
    submissionsStore.rejectSubmission(sheetPayload.value.id, selectedRejectReason.value)
    showToast('Submission rejected')
  }
  closeSheet()
}

function handleHandoffConfirm() {
  if (sheetPayload.value?.id) {
    claimsStore.verifyAndArrangeHandoff(
      sheetPayload.value.id,
      selectedPickupPoint.value,
      selectedTimeSlot.value
    )
    showToast('Handoff scheduled and SMS sent')
  }
  closeSheet()
}

function handleStartBulkUpload() {
  isUploading.value = true
  uploadProgress.value = 0

  setTimeout(() => {
    uploadProgress.value = 100
  }, 100)

  setTimeout(() => {
    submissionsStore.addBulkSubmissions(selectedPartner.value, [
      { type: 'id', town: 'Douala' },
      { type: 'birth', town: 'Garoua' },
      { type: 'lic', town: 'Bamenda' }
    ])
    showToast('3 documents added to the review queue')
    isUploading.value = false
    uploadProgress.value = 0
    closeSheet()
  }, 1400)
}
</script>

<template>
  <div>
    <!-- Scrim Backdrop -->
    <div
      class="fixed inset-0 bg-black/50 z-40 transition-opacity duration-300"
      :class="[
        isOpen ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'
      ]"
      @click="closeSheet"
    />

    <!-- Bottom Sheet Modal -->
    <div
      class="fixed left-1/2 bottom-0 w-[min(520px,100%)] bg-surf rounded-t-3xl p-6 pb-[calc(env(safe-area-inset-bottom,0px)+24px)] z-50 shadow-2xl transition-transform duration-400 ease-[cubic-bezier(0.2,0.9,0.2,1)] max-h-[90dvh] overflow-y-auto"
      :class="[
        isOpen ? 'translate-x-[-50%] translate-y-0' : 'translate-x-[-50%] translate-y-[105%]'
      ]"
      role="dialog"
      aria-modal="true"
    >
      <!-- REJECT MODAL -->
      <div v-if="activeType === 'reject'" class="space-y-4">
        <h2 class="text-xl font-bold font-display text-ink">Reject submission</h2>
        <p class="text-mute text-sm">
          The finder gets a short explanation.
        </p>
        <div>
          <label class="block text-xs font-semibold text-mute mb-1" for="reject-reason">
            Reason for rejection
          </label>
          <select
            id="reject-reason"
            v-model="selectedRejectReason"
            class="w-full bg-bg text-ink border-[1.5px] border-line rounded-xl p-2.5 text-sm focus:border-g focus:outline-none"
          >
            <option v-for="reason in REJECT_SUBMISSION_REASONS" :key="reason" :value="reason">
              {{ reason }}
            </option>
          </select>
        </div>
        <div class="flex gap-2.5 pt-2">
          <AppButton variant="red" @click="handleRejectConfirm">
            Reject
          </AppButton>
          <AppButton variant="alt" @click="closeSheet">
            Cancel
          </AppButton>
        </div>
      </div>

      <!-- HANDOFF MODAL -->
      <div v-else-if="activeType === 'handoff'" class="space-y-4">
        <h2 class="text-xl font-bold font-display text-ink">Arrange handoff</h2>
        <p class="text-mute text-sm">
          {{ sheetPayload?.who || 'Claimant' }} will be told where to go. The finder’s details stay private.
        </p>
        <div>
          <label class="block text-xs font-semibold text-mute mb-1" for="pickup-point">
            Handoff point
          </label>
          <select
            id="pickup-point"
            v-model="selectedPickupPoint"
            class="w-full bg-bg text-ink border-[1.5px] border-line rounded-xl p-2.5 text-sm focus:border-g focus:outline-none"
          >
            <option v-for="point in HANDOFF_PICKUP_POINTS" :key="point" :value="point">
              {{ point }}
            </option>
          </select>
        </div>
        <div>
          <label class="block text-xs font-semibold text-mute mb-1" for="time-slot">
            Date & Time
          </label>
          <select
            id="time-slot"
            v-model="selectedTimeSlot"
            class="w-full bg-bg text-ink border-[1.5px] border-line rounded-xl p-2.5 text-sm focus:border-g focus:outline-none"
          >
            <option v-for="slot in HANDOFF_TIME_SLOTS" :key="slot" :value="slot">
              {{ slot }}
            </option>
          </select>
        </div>
        <div class="flex gap-2.5 pt-2">
          <AppButton variant="primary" @click="handleHandoffConfirm">
            Confirm and notify
          </AppButton>
          <AppButton variant="alt" @click="closeSheet">
            Cancel
          </AppButton>
        </div>
      </div>

      <!-- BULK CSV MODAL -->
      <div v-else-if="activeType === 'bulk'" class="space-y-4">
        <h2 class="text-xl font-bold font-display text-ink">Bulk post from a partner</h2>
        <p class="text-mute text-sm">
          Prefectures, consulates and universities can upload a CSV. Every row is redacted by the same rules and goes through the queue.
        </p>
        <div>
          <label class="block text-xs font-semibold text-mute mb-1" for="partner-inst">
            Partner institution
          </label>
          <select
            id="partner-inst"
            v-model="selectedPartner"
            class="w-full bg-bg text-ink border-[1.5px] border-line rounded-xl p-2.5 text-sm focus:border-g focus:outline-none"
          >
            <option v-for="inst in PARTNER_INSTITUTIONS" :key="inst" :value="inst">
              {{ inst }}
            </option>
          </select>
        </div>

        <AppButton
          variant="primary"
          :disabled="isUploading"
          @click="handleStartBulkUpload"
        >
          Choose CSV (demo file)
        </AppButton>

        <div
          v-if="isUploading"
          class="h-2 bg-bg rounded-full overflow-hidden mt-3 transition-all"
        >
          <div
            class="h-full bg-g transition-all duration-1000 ease-out"
            :style="{ width: `${uploadProgress}%` }"
          />
        </div>
      </div>
    </div>
  </div>
</template>
