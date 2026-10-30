import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Claim } from '../types/models'
import { INITIAL_CLAIMS, DOCUMENT_TYPE_LABELS } from '../data/seed'
import { useAuditStore } from './auditStore'
import { useListingsStore } from './listingsStore'
import { useFraudStore } from './fraudStore'

export const useClaimsStore = defineStore('claims', () => {
  const claims = ref<Claim[]>(
    INITIAL_CLAIMS.map((c) => ({
      ...c,
      sig: [...c.sig],
      msgs: c.msgs.map((m) => [...m]),
      d: { ...c.d }
    }))
  )
  const selectedId = ref<number | null>(null)

  const auditStore = useAuditStore()
  const listingsStore = useListingsStore()
  const fraudStore = useFraudStore()

  const newClaimsCount = computed(() => claims.value.filter((c) => c.st === 'new').length)

  const selectedClaim = computed(() => {
    if (selectedId.value === null) return null
    return claims.value.find((c) => c.id === selectedId.value) || null
  })

  function selectClaim(id: number | null) {
    selectedId.value = id
  }

  function sendMessage(id: number, text: string, autoReply = true) {
    const trimmed = text.trim()
    if (!trimmed) return

    const claim = claims.value.find((c) => c.id === id)
    if (!claim) return

    claim.msgs.push(['a', trimmed])

    if (autoReply) {
      setTimeout(() => {
        claim.msgs.push(['u', 'Thank you, I understand.'])
      }, 1400)
    }
  }

  function verifyAndArrangeHandoff(id: number, pickupPoint: string, timeSlot: string) {
    const claim = claims.value.find((c) => c.id === id)
    if (!claim) return

    claim.st = 'handoff'
    claim.msgs.push([
      'a',
      `Your claim is verified. Please come to ${pickupPoint} on ${timeSlot} with your original ID.`
    ])

    const label = DOCUMENT_TYPE_LABELS[claim.type]
    auditStore.log(`verified claim and scheduled handoff: ${label} · ${claim.town}`)
  }

  function requestMoreProof(id: number) {
    const claim = claims.value.find((c) => c.id === id)
    if (!claim) return

    claim.st = 'more'
    claim.msgs.push([
      'a',
      'Please send a clear photo of your own ID so we can confirm.'
    ])

    auditStore.log(`requested more proof from ${claim.who}`)
  }

  function rejectAndFlag(id: number) {
    const claim = claims.value.find((c) => c.id === id)
    if (!claim) return

    claim.st = 'rejected'
    claim.msgs.push([
      'a',
      'We could not verify this claim, so we cannot release the document.'
    ])

    const label = DOCUMENT_TYPE_LABELS[claim.type]
    fraudStore.addReport({
      id: Date.now(),
      who: claim.who,
      why: `Claim rejected for ${label}: proof did not match.`,
      by: 'Admin flag',
      sev: claim.risk === 'High' ? 'High' : 'Medium',
      st: 'open'
    })

    auditStore.log(`rejected claim and flagged ${claim.who}`, true)
  }

  function markHandedOver(id: number) {
    const claim = claims.value.find((c) => c.id === id)
    if (!claim) return

    claim.st = 'done'

    // Update matching listing in listings store to Recovered
    const listing = listingsStore.listings.find(
      (l) => l.type === claim.type && l.town === claim.town && l.st === 'Live'
    )
    if (listing) {
      listing.st = 'Recovered'
    }

    const label = DOCUMENT_TYPE_LABELS[claim.type]
    auditStore.log(`marked handed over: ${label} · ${claim.town}`)
  }

  return {
    claims,
    selectedId,
    selectedClaim,
    newClaimsCount,
    selectClaim,
    sendMessage,
    verifyAndArrangeHandoff,
    requestMoreProof,
    rejectAndFlag,
    markHandedOver
  }
})
