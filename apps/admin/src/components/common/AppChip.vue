<script setup lang="ts">
withDefaults(
  defineProps<{
    active?: boolean
  }>(),
  {
    active: false
  }
)

defineEmits<{
  (e: 'click', event: MouseEvent): void
}>()
</script>

<template>
  <button
    type="button"
    class="px-3 py-1 rounded-full border-[1.5px] text-[13px] font-medium transition cursor-pointer select-none inline-flex items-center gap-1"
    :class="[
      active
        ? 'bg-g border-g text-onG'
        : 'border-line text-ink hover:border-g/40'
    ]"
    @click="$emit('click', $event)"
  >
    <slot />
  </button>
</template>
