<script setup lang="ts">
import { ref, computed } from 'vue'
import { useClaimsStore } from '../../stores/claimsStore'
import { useModalSheet } from '../../composables/useModalSheet'
import { useToast } from '../../composables/useToast'
import { DOCUMENT_TYPE_LABELS, createDefaultRedaction } from '../../data/seed'
import AppButton from '../../components/common/AppButton.vue'
import AppPill from '../../components/common/AppPill.vue'
import AppChip from '../../components/common/AppChip.vue'
import RedactedDoc from '../../components/common/RedactedDoc.vue'

const claimsStore = useClaimsStore()
const { openSheet } = useModalSheet()
const { showToast } = useToast()

const replyMessage = ref('')

const selectedClaim = computed(() => {
  if (claimsStore.selectedClaim) {
    return claimsStore.selectedClaim
  }
  // Default to first item on wider screens
  if (typeof window !== 'undefined' && window.innerWidth > 820 && claimsStore.claims.length > 0) {
    return claimsStore.claims[0]
  }
  return null
})

function selectClaim(id: number) {
  claimsStore.selectClaim(id)
}

function clearSelection() {
  claimsStore.selectClaim(null)
}

const statusLabels: Record<string, string> = {
  new: 'Awaiting review',
  handoff: 'Handoff scheduled',
  done: 'Handed over',
  rejected: 'Rejected',
  more: 'Awaiting more proof'
}

const quickReplies = [
  'Please bring your original ID to the handoff point.',
  'Can you send a clearer photo of your ID?',
  'Your claim is verified.'
]

function handleSendReply(id: number, text?: string) {
  const content = text || replyMessage.value
  if (!content.trim()) return

  claimsStore.sendMessage(id, content)
  replyMessage.value = ''
  showToast('Reply sent')
}

function handleHandoffSheet(claim: any) {
  openSheet('handoff', claim)
}

function handleRequestMoreProof(id: number) {
  claimsStore.requestMoreProof(id)
  showToast('Request sent')
}

function handleRejectAndFlag(id: number) {
  claimsStore.rejectAndFlag(id)
  showToast('Claim rejected and added to fraud reports')
}

function handleMarkHandedOver(id: number) {
  claimsStore.markHandedOver(id)
  showToast('Marked as recovered. It left public search.')
}
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-[340px_1fr] gap-4 items-start">
    <!-- Master List -->
    <div
      class="grid gap-2.5"
      :class="[
        selectedClaim ? 'max-md:hidden' : 'block'
      ]"
    >
      <button
        v-for="(claim, i) in claimsStore.claims"
        :key="claim.id"
        type="button"
        class="flex gap-3 text-left w-full p-3 border-[1.5px] rounded-2xl bg-surf transition-all duration-200 animate-in cursor-pointer select-none"
        :class="[
          selectedClaim && selectedClaim.id === claim.id
            ? 'border-g bg-g2'
            : 'border-line hover:border-g/60'
        ]"
        :style="{ animationDelay: `${i * 50}ms` }"
        @click="selectClaim(claim.id)"
      >
        <div class="flex-1">
          <div class="flex gap-1.5 flex-wrap items-center">
            <AppPill
              :variant="claim.risk === 'Low' ? 'default' : claim.risk === 'High' ? 'r' : 'w'"
            >
              {{ claim.risk }} risk
            </AppPill>
            <AppPill variant="m">
              {{ statusLabels[claim.st] || claim.st }}
            </AppPill>
          </div>
          <div class="font-semibold text-ink text-sm mt-1">
            {{ claim.who }}
          </div>
          <div class="text-mute text-xs mt-0.5 leading-snug">
            {{ DOCUMENT_TYPE_LABELS[claim.type] }} · {{ claim.town }} · {{ claim.ago }}
          </div>
        </div>
      </button>
    </div>

    <!-- Detail Panel -->
    <div
      v-if="selectedClaim"
      class="grid gap-3.5 animate-in"
      :class="[
        selectedClaim ? 'block' : 'max-md:hidden'
      ]"
    >
      <!-- Mobile Back Button -->
      <button
        type="button"
        class="hidden max-md:inline-flex items-center gap-1 font-semibold text-g text-sm cursor-pointer mb-1"
        @click="clearSelection"
      >
        ← Back to claims
      </button>

      <!-- Side-by-side Public Listing & Proof Verification -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
        <!-- Public Listing Preview -->
        <div class="app-card p-4.5">
          <div class="text-xs font-semibold text-mute mb-2">
            <span>PUBLIC LISTING</span>
          </div>
          <RedactedDoc
            :type="selectedClaim.type"
            :data="selectedClaim.d"
            :redaction="createDefaultRedaction()"
          />
        </div>

        <!-- Proof of Ownership Comparison -->
        <div class="app-card p-4.5">
          <div class="flex justify-between items-center text-xs font-semibold text-mute mb-2">
            <span>PROOF OF OWNERSHIP</span>
            <AppPill
              :variant="selectedClaim.risk === 'Low' ? 'default' : selectedClaim.risk === 'High' ? 'r' : 'w'"
            >
              {{ selectedClaim.risk }} risk
            </AppPill>
          </div>

          <!-- Comparison Grid -->
          <div class="grid grid-cols-[1fr_1fr_40px] gap-2 text-[13.5px] items-center border-b border-line pb-2.5">
            <b class="text-xs text-mute font-semibold">Document says</b>
            <b class="text-xs text-mute font-semibold">Claimant answered</b>
            <b class="text-xs text-mute font-semibold"></b>

            <span class="text-ink">{{ selectedClaim.exp }}</span>
            <span class="text-ink">{{ selectedClaim.got }}</span>
            <span
              class="font-extrabold text-base text-center"
              :class="selectedClaim.m ? 'text-g' : 'text-red'"
            >
              {{ selectedClaim.m ? '✓' : '✗' }}
            </span>
          </div>

          <p class="text-mute text-xs my-2 italic">
            Question asked: “{{ selectedClaim.ques }}”
          </p>

          <!-- Signals -->
          <div class="space-y-1 mt-2">
            <div
              v-for="(sig, idx) in selectedClaim.sig"
              :key="idx"
              class="text-[13px] flex items-center gap-1.5"
            >
              <span>{{ /wrong|No ID|Same/.test(sig) ? '⚠️' : '✅' }}</span>
              <span class="text-ink">{{ sig }}</span>
            </div>
          </div>

          <!-- Claimant Meta -->
          <div class="grid grid-cols-[80px_1fr] gap-x-2 gap-y-1.5 text-[13.5px] mt-3 pt-2.5 border-t border-line">
            <span class="text-mute">Claimant</span>
            <b class="text-ink font-semibold">{{ selectedClaim.who }}</b>

            <span class="text-mute">Phone</span>
            <b class="text-ink font-semibold">{{ selectedClaim.tel }}</b>

            <span class="text-mute">Status</span>
            <b class="text-ink font-semibold">{{ statusLabels[selectedClaim.st] || selectedClaim.st }}</b>
          </div>
        </div>
      </div>

      <!-- Claimant Conversation Card -->
      <div class="app-card p-4.5">
        <div class="text-xs font-semibold text-mute mb-2">
          <span>CONVERSATION (claimant ↔ admin)</span>
        </div>

        <!-- Chat messages list -->
        <div class="grid gap-2 max-h-[210px] overflow-y-auto py-1">
          <div
            v-for="(msg, idx) in selectedClaim.msgs"
            :key="idx"
            class="max-w-[82%] px-3 py-2 rounded-2xl text-[13.5px] animate-in"
            :class="[
              msg[0] === 'a'
                ? 'bg-g text-onG justify-self-end rounded-br-[4px]'
                : 'bg-bg text-ink rounded-bl-[4px]'
            ]"
          >
            {{ msg[1] }}
          </div>
        </div>

        <!-- Quick Response Chips & Input Box -->
        <div
          v-if="selectedClaim.st === 'new' || selectedClaim.st === 'more' || selectedClaim.st === 'handoff'"
          class="mt-3 pt-2.5 border-t border-line"
        >
          <!-- Quick Replies Chips -->
          <div class="flex gap-1.5 flex-wrap mb-2.5">
            <AppChip
              v-for="reply in quickReplies"
              :key="reply"
              @click="handleSendReply(selectedClaim.id, reply)"
            >
              {{ reply }}
            </AppChip>
          </div>

          <!-- Text Input & Send Button -->
          <div class="flex gap-2 items-center">
            <input
              v-model="replyMessage"
              type="text"
              placeholder="Write a reply"
              aria-label="Reply"
              class="flex-1 bg-bg text-ink border-[1.5px] border-transparent rounded-xl px-3 py-2 text-sm focus:border-g focus:outline-none"
              @keydown.enter="handleSendReply(selectedClaim.id)"
            />
            <AppButton size="sm" @click="handleSendReply(selectedClaim.id)">
              Send
            </AppButton>
          </div>
        </div>
      </div>

      <!-- Action Buttons Card -->
      <div class="app-card p-4.5 flex gap-2.5 items-center flex-wrap">
        <template v-if="selectedClaim.st === 'new' || selectedClaim.st === 'more'">
          <AppButton variant="primary" @click="handleHandoffSheet(selectedClaim)">
            Verify and arrange handoff
          </AppButton>
          <AppButton variant="alt" @click="handleRequestMoreProof(selectedClaim.id)">
            Request more proof
          </AppButton>
          <AppButton variant="red" @click="handleRejectAndFlag(selectedClaim.id)">
            Reject and flag
          </AppButton>
        </template>

        <template v-else-if="selectedClaim.st === 'handoff'">
          <AppButton variant="primary" @click="handleMarkHandedOver(selectedClaim.id)">
            Mark as handed over
          </AppButton>
        </template>

        <template v-else>
          <AppPill variant="m">No further action needed</AppPill>
        </template>
      </div>
    </div>
  </div>
</template>
