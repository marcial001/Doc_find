import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { FraudReport, FraudStatus } from '../types/models'
import { INITIAL_FRAUD_REPORTS } from '../data/seed'
import { useAuditStore } from './auditStore'

export const useFraudStore = defineStore('fraud', () => {
  const reports = ref<FraudReport[]>(INITIAL_FRAUD_REPORTS.map((r) => ({ ...r })))
  const auditStore = useAuditStore()

  const openCount = computed(() => reports.value.filter((f) => f.st === 'open').length)

  function addReport(report: FraudReport) {
    reports.value.unshift(report)
  }

  function updateStatus(id: number, status: FraudStatus) {
    const report = reports.value.find((r) => r.id === id)
    if (report) {
      report.st = status
      const isSensitive = status === 'Suspended'
      const action = status === 'Suspended' ? `suspended user ${report.who}` : `dismissed report on ${report.who}`
      auditStore.log(action, isSensitive)
    }
  }

  function suspendUser(id: number) {
    updateStatus(id, 'Suspended')
  }

  function dismissReport(id: number) {
    updateStatus(id, 'Dismissed')
  }

  return {
    reports,
    openCount,
    addReport,
    updateStatus,
    suspendUser,
    dismissReport
  }
})
