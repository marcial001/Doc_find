<script setup lang="ts">
withDefaults(
  defineProps<{
    variant?: 'default' | 'w' | 'r' | 'm'
  }>(),
  {
    variant: 'default'
  }
)
</script>

<template>
  <span
    class="inline-block text-[11.5px] font-semibold px-2.5 py-0.5 rounded-full select-none"
    :class="[
      variant === 'default' ? 'bg-g2 text-g' : '',
      variant === 'w' ? 'bg-amb-tint text-amb' : '',
      variant === 'r' ? 'bg-red-tint text-red' : '',
      variant === 'm' ? 'bg-bg text-mute' : ''
    ]"
  >
    <slot />
  </span>
</template>
