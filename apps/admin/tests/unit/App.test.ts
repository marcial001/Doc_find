import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import App from '../../src/App.vue'
import { router } from '../../src/router'
import { i18n } from '../../src/i18n'

describe('App.vue', () => {
  beforeEach(async () => {
    setActivePinia(createPinia())
    await router.push('/')
    await router.isReady()
  })

  it('renders app shell with sidebar and header', () => {
    const wrapper = mount(App, {
      global: {
        plugins: [router, i18n]
      }
    })

    expect(wrapper.find('aside').exists()).toBe(true)
    expect(wrapper.find('header').exists()).toBe(true)
    expect(wrapper.find('main').exists()).toBe(true)
  })
})
