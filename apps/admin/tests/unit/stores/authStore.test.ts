import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../../../src/stores/authStore'

describe('authStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('initializes with default admin user profile', () => {
    const store = useAuthStore()
    expect(store.user.name).toBe('Antony')
    expect(store.user.initials).toBe('AN')
    expect(store.user.role).toBe('Moderator')
    expect(store.user.location).toBe('Douala')
  })
})
