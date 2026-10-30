<script setup lang="ts">
withDefaults(
  defineProps<{
    variant?: 'primary' | 'alt' | 'red'
    size?: 'sm' | 'md'
    disabled?: boolean
    type?: 'button' | 'submit' | 'reset'
  }>(),
  {
    variant: 'primary',
    size: 'md',
    disabled: false,
    type: 'button'
  }
)

defineEmits<{
  (e: 'click', event: MouseEvent): void
}>()
</script>

<template>
  <button
    :type="type"
    :disabled="disabled"
    class="font-semibold transition inline-flex items-center justify-center select-none"
    :class="[
      size === 'sm' ? 'px-3 py-1.5 text-[13px] rounded-[10px]' : 'px-4 py-2.5 text-[14.5px] rounded-[12px]',
      variant === 'primary' ? 'bg-g text-onG hover:brightness-105 active:scale-[0.98]' : '',
      variant === 'alt' ? 'bg-g2 text-g hover:brightness-95 active:scale-[0.98]' : '',
      variant === 'red' ? 'bg-red-tint text-red hover:brightness-95 active:scale-[0.98]' : '',
      disabled ? 'opacity-40 pointer-events-none cursor-not-allowed' : 'cursor-pointer'
    ]"
    @click="$emit('click', $event)"
  >
    <slot />
  </button>
</template>
