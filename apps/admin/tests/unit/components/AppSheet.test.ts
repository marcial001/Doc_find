import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import AppSheet from '../../../src/components/common/AppSheet.vue'
import { useModalSheet } from '../../../src/composables/useModalSheet'
import { useSubmissionsStore } from '../../../src/stores/submissionsStore'
import { useClaimsStore } from '../../../src/stores/claimsStore'

describe('AppSheet', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.useFakeTimers()
  })

  it('renders reject sheet, allows confirming rejection and closing', async () => {
    const { openSheet } = useModalSheet()
    const submissionsStore = useSubmissionsStore()
    const firstSub = submissionsStore.submissions[0]

    const wrapper = mount(AppSheet)
    openSheet('reject', firstSub)
    await wrapper.vm.$nextTick()

    expect(wrapper.text()).toContain('Reject submission')
    const rejectBtn = wrapper.findAll('button').find((b) => b.text() === 'Reject')
    expect(rejectBtn).toBeDefined()

    await rejectBtn?.trigger('click')
    expect(submissionsStore.submissions.some((s) => s.id === firstSub.id)).toBe(false)
  })

  it('renders handoff sheet and schedules handoff', async () => {
    const { openSheet } = useModalSheet()
    const claimsStore = useClaimsStore()
    const firstClaim = claimsStore.claims[0]

    const wrapper = mount(AppSheet)
    openSheet('handoff', firstClaim)
    await wrapper.vm.$nextTick()

    expect(wrapper.text()).toContain('Arrange handoff')
    const confirmBtn = wrapper.findAll('button').find((b) => b.text() === 'Confirm and notify')
    expect(confirmBtn).toBeDefined()

    await confirmBtn?.trigger('click')
    expect(firstClaim.st).toBe('handoff')
  })

  it('renders bulk post sheet and simulates upload', async () => {
    const { openSheet } = useModalSheet()
    const submissionsStore = useSubmissionsStore()
    const prevCount = submissionsStore.submissions.length

    const wrapper = mount(AppSheet)
    openSheet('bulk')
    await wrapper.vm.$nextTick()

    expect(wrapper.text()).toContain('Bulk post from a partner')
    const chooseBtn = wrapper.findAll('button').find((b) => b.text().includes('Choose CSV'))
    await chooseBtn?.trigger('click')

    // Fast-forward animation & timeout
    vi.advanceTimersByTime(1600)
    await wrapper.vm.$nextTick()

    expect(submissionsStore.submissions.length).toBe(prevCount + 3)
  })
})
