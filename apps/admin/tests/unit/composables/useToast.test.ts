import { describe, it, expect, beforeEach, vi } from 'vitest'
import { useToast } from '../../../src/composables/useToast'

describe('useToast', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  it('shows toast with message and auto-hides after duration', () => {
    const { message, isVisible, showToast } = useToast()

    showToast('Document approved', 2000)
    expect(message.value).toBe('Document approved')
    expect(isVisible.value).toBe(true)

    vi.advanceTimersByTime(2000)
    expect(isVisible.value).toBe(false)
  })

  it('manually hides toast', () => {
    const { isVisible, showToast, hideToast } = useToast()

    showToast('Hello')
    expect(isVisible.value).toBe(true)

    hideToast()
    expect(isVisible.value).toBe(false)
  })
})
