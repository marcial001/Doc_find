import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { AdminUser } from '../types/models'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<AdminUser>({
    name: 'Antony',
    initials: 'AN',
    role: 'Moderator',
    location: 'Douala'
  })

  return {
    user
  }
})
