import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import RedactedDoc from '../../../src/components/common/RedactedDoc.vue'
import { createDefaultRedaction } from '../../../src/data/seed'

describe('RedactedDoc', () => {
  const sampleData = {
    name: 'Kevin Nkeng',
    num: '1020 4457 8812',
    dob: '12 Mar 1996',
    addr: 'Bonanjo, Douala'
  }

  it('renders unredacted original document when redaction is null and unlocked', () => {
    const wrapper = mount(RedactedDoc, {
      props: {
        type: 'id',
        data: sampleData,
        redaction: null,
        isLocked: false
      }
    })

    expect(wrapper.text()).toContain('ID CARD')
    expect(wrapper.text()).toContain('REPUBLIC OF CAMEROON')
    expect(wrapper.text()).toContain('Kevin Nkeng')
    expect(wrapper.text()).toContain('1020 4457 8812')
    expect(wrapper.text()).not.toContain('Original is hidden')
  })

  it('renders locked original overlay with reveal button and emits reveal', async () => {
    const wrapper = mount(RedactedDoc, {
      props: {
        type: 'pass',
        data: sampleData,
        redaction: null,
        isLocked: true
      }
    })

    expect(wrapper.text()).toContain('Original is hidden')
    expect(wrapper.text()).toContain('Viewing is logged')

    const button = wrapper.find('button')
    expect(button.exists()).toBe(true)
    await button.trigger('click')

    expect(wrapper.emitted('reveal')).toHaveLength(1)
  })

  it('renders redacted version masking name and hiding details with black bars', () => {
    const redaction = createDefaultRedaction()
    const wrapper = mount(RedactedDoc, {
      props: {
        type: 'id',
        data: sampleData,
        redaction: redaction,
        isLocked: false
      }
    })

    // Masked name (K•••• N••••)
    expect(wrapper.text()).toContain('K•••• N••••')
    expect(wrapper.text()).not.toContain('Kevin Nkeng')
  })
})
