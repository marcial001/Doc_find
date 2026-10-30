import { ref } from 'vue'

const message = ref('')
const isVisible = ref(false)
let timer: ReturnType<typeof setTimeout> | null = null

export function useToast() {
  function showToast(msg: string, duration = 2800) {
    if (timer) clearTimeout(timer)
    message.value = msg
    isVisible.value = true

    timer = setTimeout(() => {
      isVisible.value = false
    }, duration)
  }

  function hideToast() {
    if (timer) clearTimeout(timer)
    isVisible.value = false
  }

  return {
    message,
    isVisible,
    showToast,
    hideToast
  }
}
