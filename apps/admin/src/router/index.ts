import { createRouter, createWebHistory } from 'vue-router'
import OverviewView from '../features/overview/OverviewView.vue'
import ReviewView from '../features/review/ReviewView.vue'
import ClaimsView from '../features/claims/ClaimsView.vue'
import ListingsView from '../features/listings/ListingsView.vue'
import FraudView from '../features/fraud/FraudView.vue'
import AuditView from '../features/audit/AuditView.vue'
import SettingsView from '../features/settings/SettingsView.vue'
import LoginView from '../features/auth/LoginView.vue'

export const routes = [
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { title: 'Sign In' }
  },
  {
    path: '/',
    name: 'overview',
    component: OverviewView,
    meta: { title: 'Overview' }
  },
  {
    path: '/queue',
    name: 'queue',
    component: ReviewView,
    meta: { title: 'Review queue' }
  },
  {
    path: '/claims',
    name: 'claims',
    component: ClaimsView,
    meta: { title: 'Claims' }
  },
  {
    path: '/listings',
    name: 'listings',
    component: ListingsView,
    meta: { title: 'Listings' }
  },
  {
    path: '/fraud',
    name: 'fraud',
    component: FraudView,
    meta: { title: 'Fraud reports' }
  },
  {
    path: '/audit',
    name: 'audit',
    component: AuditView,
    meta: { title: 'Audit log' }
  },
  {
    path: '/settings',
    name: 'settings',
    component: SettingsView,
    meta: { title: 'Settings' }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

export const router = createRouter({
  history: createWebHistory(),
  routes
})

router.afterEach((to) => {
  const pageTitle = (to.meta?.title as string) || 'Doc-Find Admin'
  document.title = `${pageTitle} · Doc-Find Admin`
})
