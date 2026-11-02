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
    expect(store.isAuthenticated).toBe(true)
  })

  it('authenticates valid credentials and updates user profile', () => {
    const store = useAuthStore()
    const result = store.login('admin@docfind.cm', 'admin1234')
    expect(result).toBe(true)
    expect(store.isAuthenticated).toBe(true)
    expect(store.user.name).toBe('Antony')
  })

  it('rejects invalid credentials', () => {
    const store = useAuthStore()
    const result = store.login('wrong@docfind.cm', '123')
    expect(result).toBe(false)
  })

  it('clears token on logout', () => {
    const store = useAuthStore()
    store.logout()
    expect(store.token).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })
})
