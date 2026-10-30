<script setup lang="ts">
import { computed, onMounted, onUnmounted } from 'vue'
import { useSubmissionsStore } from '../../stores/submissionsStore'
import { useModalSheet } from '../../composables/useModalSheet'
import { useToast } from '../../composables/useToast'
import { DOCUMENT_TYPE_LABELS } from '../../data/seed'
import AppButton from '../../components/common/AppButton.vue'
import AppPill from '../../components/common/AppPill.vue'
import AppSwitch from '../../components/common/AppSwitch.vue'
import RedactedDoc from '../../components/common/RedactedDoc.vue'

const submissionsStore = useSubmissionsStore()
const { openSheet } = useModalSheet()
const { showToast } = useToast()

const selectedSubmission = computed(() => {
  if (submissionsStore.selectedSubmission) {
    return submissionsStore.selectedSubmission
  }
  // Default to first item on wider screens if none selected
  if (typeof window !== 'undefined' && window.innerWidth > 820 && submissionsStore.submissions.length > 0) {
    return submissionsStore.submissions[0]
  }
  return null
})

function selectItem(id: number) {
  submissionsStore.selectSubmission(id)
}

function clearSelection() {
  submissionsStore.selectSubmission(null)
}

function handleReveal(id: number) {
  submissionsStore.revealOriginal(id)
  showToast('Original revealed and logged')
}

function handleApprove(id: number) {
  submissionsStore.approveSubmission(id)
  showToast('Published with redaction. The finder was notified.')
}

function handleRetake(id: number) {
  const item = submissionsStore.submissions.find((s) => s.id === id)
  submissionsStore.requestRetake(id)
  showToast(`Message sent to ${item?.finder || 'finder'}`)
}

function handleReject(id: number) {
  const item = submissionsStore.submissions.find((s) => s.id === id)
  if (item) {
    openSheet('reject', item)
  }
}

// Keyboard shortcuts: 'A' to approve, 'R' to reject, Arrow keys to navigate
function handleKeydown(e: KeyboardEvent) {
  const target = e.target as HTMLElement
  if (target && ['INPUT', 'TEXTAREA', 'SELECT'].includes(target.tagName)) {
    return
  }

  const current = selectedSubmission.value
  if (!current) return

  if (e.key === 'a' || e.key === 'A') {
    if (current.consent[0] && current.consent[1]) {
      e.preventDefault()
      handleApprove(current.id)
    }
  } else if (e.key === 'r' || e.key === 'R') {
    e.preventDefault()
    handleReject(current.id)
  } else if (e.key === 'ArrowDown') {
    e.preventDefault()
    const idx = submissionsStore.submissions.findIndex((s) => s.id === current.id)
    if (idx >= 0 && idx < submissionsStore.submissions.length - 1) {
      selectItem(submissionsStore.submissions[idx + 1].id)
    }
  } else if (e.key === 'ArrowUp') {
    e.preventDefault()
    const idx = submissionsStore.submissions.findIndex((s) => s.id === current.id)
    if (idx > 0) {
      selectItem(submissionsStore.submissions[idx - 1].id)
    }
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})
</script>

<template>
  <div>
    <!-- Empty Queue State -->
    <div
      v-if="submissionsStore.submissions.length === 0"
      class="bg-surf border border-line rounded-[18px] p-12 text-center text-mute"
    >
      <div class="text-4xl mb-3">✅</div>
      <h3 class="font-display font-bold text-lg text-ink">Queue is clear</h3>
      <p class="text-sm mt-1">New submissions from finders will appear here.</p>
    </div>

    <!-- Master-Detail Layout -->
    <div
      v-else
      class="grid grid-cols-1 md:grid-cols-[340px_1fr] gap-4 items-start"
    >
      <!-- Master List -->
      <div
        class="grid gap-2.5"
        :class="[
          selectedSubmission ? 'max-md:hidden' : 'block'
        ]"
      >
        <button
          v-for="(sub, i) in submissionsStore.submissions"
          :key="sub.id"
          type="button"
          class="flex gap-3 text-left w-full p-3 border-[1.5px] rounded-2xl bg-surf transition-all duration-200 animate-in cursor-pointer select-none"
          :class="[
            selectedSubmission && selectedSubmission.id === sub.id
              ? 'border-g bg-g2'
              : 'border-line hover:border-g/60'
          ]"
          :style="{ animationDelay: `${i * 50}ms` }"
          @click="selectItem(sub.id)"
        >
          <div class="flex-1">
            <AppPill :variant="sub.q === 'Sharp' ? 'default' : 'w'">
              {{ sub.q }}
            </AppPill>
            <div class="font-semibold text-ink text-sm mt-1">
              {{ DOCUMENT_TYPE_LABELS[sub.type] }} · {{ sub.town }}
            </div>
            <div class="text-mute text-xs mt-0.5 leading-snug">
              {{ sub.spot }}<br />
              Found by {{ sub.finder }} · {{ sub.ago }}
            </div>
          </div>
        </button>
      </div>

      <!-- Detail Panel -->
      <div
        v-if="selectedSubmission"
        class="grid gap-3.5 animate-in"
        :class="[
          selectedSubmission ? 'block' : 'max-md:hidden'
        ]"
      >
        <!-- Mobile Back Button -->
        <button
          type="button"
          class="hidden max-md:inline-flex items-center gap-1 font-semibold text-g text-sm cursor-pointer mb-1"
          @click="clearSelection"
        >
          ← Back to queue
        </button>

        <!-- Side-by-side Document Preview Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
          <!-- Original Preview (Admin Only) -->
          <div class="bg-surf border border-line rounded-[18px] p-4.5">
            <div class="flex justify-between items-center text-xs font-semibold text-mute mb-2">
              <span>ORIGINAL · ADMIN ONLY</span>
            </div>
            <RedactedDoc
              :type="selectedSubmission.type"
              :data="selectedSubmission.d"
              :redaction="null"
              :is-locked="!submissionsStore.isRevealed(selectedSubmission.id)"
              @reveal="handleReveal(selectedSubmission.id)"
            />
          </div>

          <!-- Public Redacted Preview -->
          <div class="bg-surf border border-line rounded-[18px] p-4.5">
            <div class="flex justify-between items-center text-xs font-semibold text-mute mb-2">
              <span>PUBLIC LISTING PREVIEW</span>
              <AppPill variant="default">Live preview</AppPill>
            </div>
            <RedactedDoc
              :type="selectedSubmission.type"
              :data="selectedSubmission.d"
              :redaction="submissionsStore.getRedaction(selectedSubmission.id)"
            />
          </div>
        </div>

        <!-- Redaction Controls & Finder/Consent Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
          <!-- Redaction Controls -->
          <div class="bg-surf border border-line rounded-[18px] p-4.5">
            <div class="text-xs font-semibold text-mute mb-2">
              <span>REDACTION</span>
            </div>
            <div class="divide-y divide-line text-sm">
              <div class="flex items-center justify-between py-2">
                <span>Partial name only (K••• N•••)</span>
                <AppSwitch
                  :model-value="submissionsStore.getRedaction(selectedSubmission.id).name"
                  label="Partial name only"
                  @change="submissionsStore.toggleRedactionField(selectedSubmission.id, 'name')"
                />
              </div>
              <div class="flex items-center justify-between py-2">
                <span>Hide ID number</span>
                <AppSwitch
                  :model-value="submissionsStore.getRedaction(selectedSubmission.id).num"
                  label="Hide ID number"
                  @change="submissionsStore.toggleRedactionField(selectedSubmission.id, 'num')"
                />
              </div>
              <div class="flex items-center justify-between py-2">
                <span>Hide date of birth</span>
                <AppSwitch
                  :model-value="submissionsStore.getRedaction(selectedSubmission.id).dob"
                  label="Hide date of birth"
                  @change="submissionsStore.toggleRedactionField(selectedSubmission.id, 'dob')"
                />
              </div>
              <div class="flex items-center justify-between py-2">
                <span>Hide address</span>
                <AppSwitch
                  :model-value="submissionsStore.getRedaction(selectedSubmission.id).addr"
                  label="Hide address"
                  @change="submissionsStore.toggleRedactionField(selectedSubmission.id, 'addr')"
                />
              </div>
              <div class="flex items-center justify-between py-2">
                <span>Blur portrait photo</span>
                <AppSwitch
                  :model-value="submissionsStore.getRedaction(selectedSubmission.id).photo"
                  label="Blur portrait photo"
                  @change="submissionsStore.toggleRedactionField(selectedSubmission.id, 'photo')"
                />
              </div>
            </div>

            <!-- Blur Strength Slider -->
            <div class="mt-2.5 pt-2 border-t border-line">
              <div class="flex justify-between text-xs text-mute mb-1 font-medium">
                <span>Blur strength</span>
                <span>{{ submissionsStore.getRedaction(selectedSubmission.id).blur }}px</span>
              </div>
              <input
                type="range"
                min="2"
                max="14"
                :value="submissionsStore.getRedaction(selectedSubmission.id).blur"
                class="w-full accent-g cursor-pointer"
                aria-label="Blur strength"
                @input="submissionsStore.setBlurStrength(selectedSubmission.id, Number(($event.target as HTMLInputElement).value))"
              />
            </div>
          </div>

          <!-- Finder and Consent Card -->
          <div class="bg-surf border border-line rounded-[18px] p-4.5">
            <div class="text-xs font-semibold text-mute mb-2">
              <span>FINDER AND CONSENT</span>
            </div>
            <div class="grid grid-cols-[110px_1fr] gap-x-3 gap-y-2 text-[13.5px]">
              <span class="text-mute">Finder</span>
              <b class="text-ink font-semibold">{{ selectedSubmission.finder }}</b>

              <span class="text-mute">Phone</span>
              <b class="text-ink font-semibold">{{ selectedSubmission.tel }}</b>

              <span class="text-mute">Found at</span>
              <b class="text-ink font-semibold">{{ selectedSubmission.spot }}, {{ selectedSubmission.town }}</b>

              <span class="text-mute">Photo quality</span>
              <b class="text-ink font-semibold">{{ selectedSubmission.q }}</b>

              <span class="text-mute">Consent</span>
              <div class="flex gap-1.5 flex-wrap">
                <AppPill :variant="selectedSubmission.consent[0] ? 'default' : 'r'">
                  Photo {{ selectedSubmission.consent[0] ? '✓' : '✗' }}
                </AppPill>
                <AppPill :variant="selectedSubmission.consent[1] ? 'default' : 'r'">
                  Location {{ selectedSubmission.consent[1] ? '✓' : '✗' }}
                </AppPill>
                <AppPill :variant="selectedSubmission.consent[2] ? 'default' : 'w'">
                  Phone {{ selectedSubmission.consent[2] ? '✓' : '✗' }}
                </AppPill>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons Card -->
        <div class="bg-surf border border-line rounded-[18px] p-4.5 flex gap-2.5 items-center flex-wrap">
          <AppButton
            variant="primary"
            :disabled="!selectedSubmission.consent[0] || !selectedSubmission.consent[1]"
            @click="handleApprove(selectedSubmission.id)"
          >
            Approve and publish
          </AppButton>
          <AppButton
            variant="alt"
            @click="handleRetake(selectedSubmission.id)"
          >
            Ask for a better photo
          </AppButton>
          <AppButton
            variant="red"
            @click="handleReject(selectedSubmission.id)"
          >
            Reject
          </AppButton>

          <small
            v-if="!selectedSubmission.consent[0] || !selectedSubmission.consent[1]"
            class="text-red text-xs font-semibold ml-auto"
          >
            Photo and location consent required to publish.
          </small>
        </div>
      </div>
    </div>
  </div>
</template>
