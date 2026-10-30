import { describe, it, expect } from 'vitest'
import { useModalSheet } from '../../../src/composables/useModalSheet'

describe('useModalSheet', () => {
  it('opens and closes sheets with payload', () => {
    const { isOpen, activeType, sheetPayload, openSheet, closeSheet } = useModalSheet()

    expect(isOpen.value).toBe(false)
    expect(activeType.value).toBeNull()

    openSheet('reject', { id: 123, who: 'Tester' })
    expect(isOpen.value).toBe(true)
    expect(activeType.value).toBe('reject')
    expect(sheetPayload.value).toEqual({ id: 123, who: 'Tester' })

    closeSheet()
    expect(isOpen.value).toBe(false)
    expect(activeType.value).toBeNull()
    expect(sheetPayload.value).toBeNull()
  })
})
