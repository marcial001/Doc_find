<script setup lang="ts">
import { useToast } from '../../composables/useToast'

const { message, isVisible } = useToast()
</script>

<template>
  <div
    class="fixed left-1/2 bottom-[calc(env(safe-area-inset-bottom,0px)+24px)] z-50 px-4 py-3 rounded-2xl bg-ink text-surf font-medium max-w-[92vw] shadow-lg pointer-events-none transition-all duration-400 ease-[cubic-bezier(0.2,1.2,0.3,1)]"
    :class="[
      isVisible
        ? 'opacity-100 translate-x-[-50%] translate-y-0'
        : 'opacity-0 translate-x-[-50%] translate-y-12'
    ]"
    role="status"
    aria-live="polite"
  >
    {{ message }}
  </div>
</template>
