import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import AppHeader from '../../../src/components/layout/AppHeader.vue'
import { createRouter, createWebHistory } from 'vue-router'
import { useListingsStore } from '../../../src/stores/listingsStore'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: { template: 'div' }, meta: { title: 'Overview' } },
    { path: '/listings', component: { template: 'div' }, meta: { title: 'Listings' } }
  ]
})

describe('AppHeader', () => {
  beforeEach(async () => {
    setActivePinia(createPinia())
    await router.push('/')
    await router.isReady()
  })

  it('renders route title and global search input', () => {
    const wrapper = mount(AppHeader, {
      global: { plugins: [router] }
    })

    expect(wrapper.find('h1').text()).toBe('Overview')
    expect(wrapper.find('input[type="search"]').exists()).toBe(true)
  })

  it('filters listings and navigates to /listings on Enter', async () => {
    const listingsStore = useListingsStore()
    const wrapper = mount(AppHeader, {
      global: { plugins: [router] }
    })

    const input = wrapper.find('input[type="search"]')
    await input.setValue('Yaoundé')
    await input.trigger('keydown.enter')

    expect(listingsStore.searchQuery).toBe('Yaoundé')
    expect(listingsStore.statusFilter).toBe('All')
  })
})
