import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import LoginView from '../../../src/features/auth/LoginView.vue'
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../../../src/stores/authStore'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', component: LoginView },
    { path: '/', component: { template: '<div>Dashboard</div>' } }
  ]
})

describe('LoginView.vue', () => {
  beforeEach(async () => {
    setActivePinia(createPinia())
    await router.push('/login')
    await router.isReady()
  })

  it('renders login form with branding and security compliance notices', () => {
    const wrapper = mount(LoginView, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('Doc-Find')
    expect(wrapper.text()).toContain('Admin Sign In')
    expect(wrapper.text()).toContain('Law No. 2024/017')
    expect(wrapper.find('input[type="email"]').exists()).toBe(true)
    expect(wrapper.find('input[type="password"]').exists()).toBe(true)
    expect(wrapper.find('button[type="submit"]').exists()).toBe(true)
  })

  it('auto-fills demo credentials when clicking quick-fill button', async () => {
    const wrapper = mount(LoginView, {
      global: { plugins: [router] }
    })

    const quickFillBtn = wrapper.findAll('button').find((b) => b.text().includes('Auto-fill Demo Moderator'))
    expect(quickFillBtn?.exists()).toBe(true)

    await quickFillBtn?.trigger('click')

    const emailInput = wrapper.find('input[type="email"]').element as HTMLInputElement
    const passwordInput = wrapper.find('input[type="password"]').element as HTMLInputElement

    expect(emailInput.value).toBe('admin@docfind.cm')
    expect(passwordInput.value).toBe('admin1234')
  })

  it('toggles password visibility when clicking eye button', async () => {
    const wrapper = mount(LoginView, {
      global: { plugins: [router] }
    })

    expect(wrapper.find('#admin-password').attributes('type')).toBe('password')

    const eyeBtn = wrapper.find('button[title="Show password"]')
    expect(eyeBtn.exists()).toBe(true)
    await eyeBtn.trigger('click')

    expect(wrapper.find('#admin-password').attributes('type')).toBe('text')
  })

  it('displays error message on empty submission', async () => {
    const wrapper = mount(LoginView, {
      global: { plugins: [router] }
    })

    await wrapper.find('form').trigger('submit.prevent')
    expect(wrapper.text()).toContain('Please enter your administrator email address')
  })
})
