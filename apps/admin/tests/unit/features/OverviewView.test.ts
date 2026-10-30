import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import OverviewView from '../../../src/features/overview/OverviewView.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [{ path: '/', component: { template: 'div' } }, { path: '/queue', component: { template: 'div' } }]
})

describe('OverviewView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders 4 KPI cards with counts', () => {
    const wrapper = mount(OverviewView, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('Pending review')
    expect(wrapper.text()).toContain('Open claims')
    expect(wrapper.text()).toContain('Live listings')
    expect(wrapper.text()).toContain('Recovered this month')
  })

  it('renders weekly chart and recent activity feed', () => {
    const wrapper = mount(OverviewView, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('This week')
    expect(wrapper.text()).toContain('Found documents submitted')
    expect(wrapper.text()).toContain('Returned to owners')
    expect(wrapper.text()).toContain('Recent activity')
  })

  it('renders needs attention banner when queue has items', () => {
    const wrapper = mount(OverviewView, {
      global: { plugins: [router] }
    })

    expect(wrapper.text()).toContain('Needs attention')
    expect(wrapper.text()).toContain('Open review queue')
  })
})
