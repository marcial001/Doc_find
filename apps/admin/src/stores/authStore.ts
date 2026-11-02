import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AdminUser } from '../types/models'

const DEFAULT_USER: AdminUser = {
  name: 'Antony',
  initials: 'AN',
  role: 'Moderator',
  location: 'Douala'
}

function getStoredToken(): string | null {
  try {
    if (typeof window !== 'undefined' && window.localStorage && typeof window.localStorage.getItem === 'function') {
      return window.localStorage.getItem('docfind_admin_token')
    }
  } catch {
    // ignore
  }
  return null
}

function setStoredToken(val: string | null) {
  try {
    if (typeof window !== 'undefined' && window.localStorage && typeof window.localStorage.setItem === 'function') {
      if (val) {
        window.localStorage.setItem('docfind_admin_token', val)
      } else {
        window.localStorage.removeItem('docfind_admin_token')
      }
    }
  } catch {
    // ignore
  }
}

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(getStoredToken() || 'demo-admin-token')
  const user = ref<AdminUser>({ ...DEFAULT_USER })

  const isAuthenticated = computed(() => !!token.value)

  function login(email: string, pass: string): boolean {
    if (
      (email === 'admin@docfind.cm' && pass === 'admin1234') ||
      (email === 'demo@docfind.cm' && pass === 'demo1234') ||
      (email.includes('@') && pass.length >= 6)
    ) {
      token.value = 'admin-jwt-token-active'
      setStoredToken(token.value)
      user.value = {
        name: email.startsWith('admin') ? 'Antony' : 'K. N.',
        initials: email.startsWith('admin') ? 'AN' : 'KN',
        role: email.startsWith('admin') ? 'Moderator' : 'Verification Officer',
        location: 'Douala'
      }
      return true
    }
    return false
  }

  function logout() {
    token.value = null
    setStoredToken(null)
  }

  return {
    user,
    token,
    isAuthenticated,
    login,
    logout
  }
})
