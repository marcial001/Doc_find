<script setup lang="ts">
import { computed } from 'vue'
import type { DocumentType, DocumentData, RedactionSettings } from '../../types/models'
import { DOCUMENT_TYPE_LABELS } from '../../data/seed'
import AppButton from './AppButton.vue'

const props = withDefaults(
  defineProps<{
    type: DocumentType
    data: DocumentData
    redaction?: RedactionSettings | null
    isLocked?: boolean
  }>(),
  {
    redaction: null,
    isLocked: false
  }
)

const emit = defineEmits<{
  (e: 'reveal'): void
}>()

const docTheme = computed(() => {
  switch (props.type) {
    case 'pass':
      return { border: '#274C9B', bg: '#EDF2FA' }
    case 'birth':
      return { border: '#B4741C', bg: '#FAF4EB' }
    case 'lic':
      return { border: '#8A3AA3', bg: '#F6EDFA' }
    case 'other':
      return { border: '#5C6B63', bg: '#EFF1F0' }
    case 'id':
    default:
      return { border: '#2E7D5B', bg: '#EDF5F1' }
  }
})

function maskName(name: string): string {
  if (!name) return ''
  return name
    .split(' ')
    .map((word) => {
      if (!word) return ''
      return word[0] + '•'.repeat(Math.max(3, word.length - 1))
    })
    .join(' ')
}

const displayName = computed(() => {
  if (props.redaction && props.redaction.name) {
    return maskName(props.data.name)
  }
  return props.data.name
})

const photoFilterStyle = computed(() => {
  if (props.redaction && props.redaction.photo) {
    return { filter: `blur(${props.redaction.blur}px)` }
  }
  return { filter: 'none' }
})
</script>

<template>
  <div
    class="relative rounded-2xl border-2 p-3 text-ink overflow-hidden transition-all"
    :style="{ borderColor: docTheme.border, backgroundColor: docTheme.bg }"
  >
    <!-- Lock overlay for private original -->
    <div
      v-if="isLocked"
      class="absolute inset-0 bg-[#0b1a13cc] backdrop-blur-md flex flex-col items-center justify-center text-center text-white p-3.5 z-10"
    >
      <div class="text-2xl mb-1">🔒</div>
      <div class="font-semibold text-sm">Original is hidden</div>
      <small class="text-xs text-white/70 mb-2">Viewing is logged</small>
      <AppButton size="sm" @click="emit('reveal')">
        Reveal original
      </AppButton>
    </div>

    <!-- Document Header -->
    <div
      class="flex justify-between text-[10px] font-bold pb-1.5 mb-2 border-b-[1.5px]"
      :style="{ color: docTheme.border, borderColor: docTheme.border }"
    >
      <span>{{ DOCUMENT_TYPE_LABELS[type].toUpperCase() }}</span>
      <span>REPUBLIC OF CAMEROON</span>
    </div>

    <!-- Document Body -->
    <div class="flex gap-3">
      <!-- Document Portrait Photo -->
      <div
        class="flex-none w-[68px] h-[84px] rounded-lg transition-all duration-200"
        :style="{
          background: 'radial-gradient(circle at 50% 36%, #6a8c95 0 17%, transparent 18%), linear-gradient(#9bb, #567)',
          ...photoFilterStyle
        }"
      />

      <!-- Fields List -->
      <div class="flex-1 grid gap-1.5 text-[12.5px] content-start">
        <!-- Name -->
        <div>
          <i class="block not-italic text-[9.5px] text-[#555] uppercase tracking-wider">Name</i>
          <span class="font-semibold">{{ displayName }}</span>
        </div>

        <!-- Number -->
        <div>
          <i class="block not-italic text-[9.5px] text-[#555] uppercase tracking-wider">Number</i>
          <span
            v-if="redaction && redaction.num"
            class="block h-[13px] bg-[#111] rounded-[2px] w-[80%] my-0.5 animate-in"
          />
          <span v-else class="font-mono">{{ data.num }}</span>
        </div>

        <!-- Date of birth -->
        <div>
          <i class="block not-italic text-[9.5px] text-[#555] uppercase tracking-wider">Date of birth</i>
          <span
            v-if="redaction && redaction.dob"
            class="block h-[13px] bg-[#111] rounded-[2px] w-[60%] my-0.5 animate-in"
          />
          <span v-else>{{ data.dob }}</span>
        </div>

        <!-- Address -->
        <div>
          <i class="block not-italic text-[9.5px] text-[#555] uppercase tracking-wider">Address</i>
          <span
            v-if="redaction && redaction.addr"
            class="block h-[13px] bg-[#111] rounded-[2px] w-[75%] my-0.5 animate-in"
          />
          <span v-else>{{ data.addr }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
