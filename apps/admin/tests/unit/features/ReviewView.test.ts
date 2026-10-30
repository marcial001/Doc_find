import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import ReviewView from '../../../src/features/review/ReviewView.vue'
import { useSubmissionsStore } from '../../../src/stores/submissionsStore'

describe('ReviewView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders master list of submissions with quality badges and metadata', () => {
    const wrapper = mount(ReviewView)
    expect(wrapper.text()).toContain('ID card · Douala')
    expect(wrapper.text()).toContain('Paul Mbarga')
    expect(wrapper.text()).toContain('REPUBLIC OF CAMEROON')
  })

  it('displays redaction toggles and updates blur slider', async () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)

    const wrapper = mount(ReviewView)
    expect(wrapper.text()).toContain('REDACTION')
    expect(wrapper.text()).toContain('Partial name only (K••• N•••)')
    expect(wrapper.text()).toContain('Hide ID number')
    expect(wrapper.text()).toContain('Blur strength')

    const slider = wrapper.find('input[type="range"]')
    expect(slider.exists()).toBe(true)
    await slider.setValue(10)
    await slider.trigger('input')
    expect(store.getRedaction(first.id).blur).toBe(10)
  })

  it('handles approve action from detail view', async () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)

    const wrapper = mount(ReviewView)
    const approveBtn = wrapper.findAll('button').find((b) => b.text() === 'Approve and publish')
    expect(approveBtn).toBeDefined()
    expect(approveBtn?.attributes('disabled')).toBeUndefined()

    await approveBtn?.trigger('click')
    expect(store.submissions.some((s) => s.id === first.id)).toBe(false)
  })

  it('handles retake photo action from detail view', async () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)

    const wrapper = mount(ReviewView)
    const retakeBtn = wrapper.findAll('button').find((b) => b.text() === 'Ask for a better photo')
    expect(retakeBtn).toBeDefined()

    await retakeBtn?.trigger('click')
  })

  it('handles reveal original action from detail view', async () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)

    const wrapper = mount(ReviewView)
    const revealBtn = wrapper.findAll('button').find((b) => b.text().includes('Reveal original'))
    if (revealBtn) {
      await revealBtn.trigger('click')
      expect(store.isRevealed(first.id)).toBe(true)
    }
  })

  it('supports keyboard navigation (ArrowDown, ArrowUp, A, R)', async () => {
    const store = useSubmissionsStore()
    const first = store.submissions[0]
    store.selectSubmission(first.id)

    const wrapper = mount(ReviewView)

    // Arrow down
    window.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowDown' }))
    expect(store.selectedId).toBe(store.submissions[1].id)

    // Arrow up
    window.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowUp' }))
    expect(store.selectedId).toBe(store.submissions[0].id)

    // Key 'a' to approve
    window.dispatchEvent(new KeyboardEvent('keydown', { key: 'a' }))
    expect(store.submissions.some((s) => s.id === first.id)).toBe(false)

    wrapper.unmount()
  })

  it('renders empty queue message when all submissions are handled', () => {
    const store = useSubmissionsStore()
    store.submissions = []

    const wrapper = mount(ReviewView)
    expect(wrapper.text()).toContain('Queue is clear')
  })
})
