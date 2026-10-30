import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import AppSidebar from '../../../src/components/layout/AppSidebar.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: { template: 'div' } },
    { path: '/queue', component: { template: 'div' } },
    { path: '/claims', component: { template: 'div' } },
    { path: '/listings', component: { template: 'div' } },
    { path: '/fraud', component: { template: 'div' } },
    { path: '/audit', component: { template: 'div' } },
    { path: '/settings', component: { template: 'div' } }
  ]
})

describe('AppSidebar', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders navigation items with badge counts', () => {
    const wrapper = mount(AppSidebar, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('Doc-Find')
    expect(wrapper.text()).toContain('Overview')
    expect(wrapper.text()).toContain('Review queue')
    expect(wrapper.text()).toContain('Claims')
    expect(wrapper.text()).toContain('Listings')
    expect(wrapper.text()).toContain('Fraud reports')
    expect(wrapper.text()).toContain('Audit log')
    expect(wrapper.text()).toContain('Settings')
  })

  it('renders user moderator avatar and name in desktop footer', () => {
    const wrapper = mount(AppSidebar, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('Antony')
    expect(wrapper.text()).toContain('AN')
    expect(wrapper.text()).toContain('Moderator · Douala')
  })
})
