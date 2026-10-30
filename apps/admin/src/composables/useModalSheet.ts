import { ref } from 'vue'

export type SheetType = 'reject' | 'handoff' | 'bulk'

const isOpen = ref(false)
const activeType = ref<SheetType | null>(null)
const sheetPayload = ref<any>(null)

export function useModalSheet() {
  function openSheet(type: SheetType, payload?: any) {
    activeType.value = type
    sheetPayload.value = payload ?? null
    isOpen.value = true
  }

  function closeSheet() {
    isOpen.value = false
    activeType.value = null
    sheetPayload.value = null
  }

  return {
    isOpen,
    activeType,
    sheetPayload,
    openSheet,
    closeSheet
  }
}
