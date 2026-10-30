export type DocumentType = 'id' | 'pass' | 'birth' | 'lic' | 'other'

export interface DocumentData {
  name: string
  num: string
  dob: string
  addr: string
}

export interface RedactionSettings {
  name: boolean
  num: boolean
  dob: boolean
  addr: boolean
  photo: boolean
  blur: number
}

export type PhotoQuality = 'Sharp' | 'Slightly blurry' | 'Too dark: retake advised'

export interface Submission {
  id: number
  type: DocumentType
  town: string
  spot: string
  ago: string
  finder: string
  tel: string
  q: PhotoQuality
  consent: [boolean, boolean, boolean] // [photo, location, phone]
  d: DocumentData
}

export type ClaimRisk = 'Low' | 'Medium' | 'High'
export type ClaimStatus = 'new' | 'handoff' | 'done' | 'rejected' | 'more'
export type MessageSender = 'u' | 'a' // user | admin

export interface ChatMessage {
  sender: MessageSender
  text: string
  timestamp?: string
}

export interface Claim {
  id: number
  type: DocumentType
  town: string
  who: string
  tel: string
  ago: string
  ques: string
  exp: string
  got: string
  m: boolean // match
  idp: boolean // id photo attached
  risk: ClaimRisk
  st: ClaimStatus
  sig: string[] // fraud signals
  msgs: [MessageSender, string][]
  d: DocumentData
}

export type ListingStatus = 'Live' | 'Recovered' | 'Archived'

export interface Listing {
  id: number
  type: DocumentType
  town: string
  days: number
  st: ListingStatus
  views: number
  cl: number // claims count
}

export type FraudSeverity = 'Low' | 'Medium' | 'High'
export type FraudStatus = 'open' | 'Suspended' | 'Dismissed'

export interface FraudReport {
  id: number
  who: string
  why: string
  by: string
  sev: FraudSeverity
  st: FraudStatus
}

export interface AuditEvent {
  t: string
  w: string
  s: number // 0 = standard, 1 = sensitive
}

export interface ModerationSettings {
  proof: boolean
  phone: boolean
  sms: boolean
  reveal: boolean
  days: number // auto-archive inactive listings
  retain: number // delete original photos after recovery
}

export type AppTheme = 'system' | 'light' | 'dark'
export type AppLanguage = 'en' | 'fr'

export interface AdminUser {
  name: string
  initials: string
  role: string
  location: string
}
