<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    modelValue: boolean
    label?: string
    disabled?: boolean
  }>(),
  {
    modelValue: false,
    label: 'Toggle switch',
    disabled: false
  }
)

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'change', value: boolean): void
}>()

function toggle() {
  if (props.disabled) return
  const next = !props.modelValue
  emit('update:modelValue', next)
  emit('change', next)
}
</script>

<template>
  <button
    type="button"
    role="switch"
    :aria-checked="modelValue"
    :aria-label="label"
    :disabled="disabled"
    class="relative inline-flex flex-none w-11 h-[26px] rounded-full transition-colors cursor-pointer"
    :class="[
      modelValue ? 'bg-g' : 'bg-line',
      disabled ? 'opacity-40 cursor-not-allowed' : ''
    ]"
    @click="toggle"
  >
    <span
      class="absolute top-[3px] left-[3px] w-5 h-5 rounded-full bg-white shadow-sm transition-transform duration-250 ease-out"
      :class="modelValue ? 'translate-x-[18px]' : 'translate-x-0'"
    />
  </button>
</template>
