import type {
  Submission,
  Claim,
  Listing,
  FraudReport,
  AuditEvent,
  ModerationSettings,
  DocumentType,
  RedactionSettings
} from '../types/models'

export const DOCUMENT_TYPE_LABELS: Record<DocumentType, string> = {
  id: 'ID card',
  pass: 'Passport',
  birth: 'Birth certificate',
  lic: 'Driver’s licence',
  other: 'Student card'
}

export const DOCUMENT_TYPE_LABELS_FR: Record<DocumentType, string> = {
  id: "Carte d'identité",
  pass: 'Passeport',
  birth: 'Acte de naissance',
  lic: 'Permis de conduire',
  other: "Carte d'étudiant"
}

export const createDefaultRedaction = (): RedactionSettings => ({
  name: true,
  num: true,
  photo: true,
  dob: true,
  addr: true,
  blur: 7
})

export const INITIAL_SUBMISSIONS: Submission[] = [
  {
    id: 1,
    type: 'id',
    town: 'Douala',
    spot: 'Akwa, near Rond-point Deido',
    ago: '2 h ago',
    finder: 'Paul Mbarga',
    tel: '677 12 04 55',
    q: 'Sharp',
    consent: [true, true, true],
    d: {
      name: 'Kevin Nkeng',
      num: '1020 4457 8812',
      dob: '12 Mar 1996',
      addr: 'Bonanjo, Douala'
    }
  },
  {
    id: 2,
    type: 'pass',
    town: 'Yaoundé',
    spot: 'Mvan bus park',
    ago: '5 h ago',
    finder: 'Sandrine Ewane',
    tel: '690 55 21 08',
    q: 'Slightly blurry',
    consent: [true, true, true],
    d: {
      name: 'Marie Tchoua',
      num: 'CE 0481 2290',
      dob: '04 Aug 1991',
      addr: 'Bastos, Yaoundé'
    }
  },
  {
    id: 3,
    type: 'birth',
    town: 'Bafoussam',
    spot: 'Marché A',
    ago: '1 d ago',
    finder: 'Hamidou Njoya',
    tel: '651 90 33 17',
    q: 'Sharp',
    consent: [true, true, true],
    d: {
      name: 'Emmanuel Abena',
      num: 'N° 2209/2001',
      dob: '22 Jan 2001',
      addr: 'Bafoussam II'
    }
  },
  {
    id: 4,
    type: 'lic',
    town: 'Douala',
    spot: 'Bonabéri ferry quay',
    ago: '1 d ago',
    finder: 'Ines Kameni',
    tel: '699 04 76 62',
    q: 'Sharp',
    consent: [true, true, false],
    d: {
      name: 'Felix Bella',
      num: 'PC 77 301 884',
      dob: '30 Sep 1988',
      addr: 'Bonabéri, Douala'
    }
  },
  {
    id: 5,
    type: 'id',
    town: 'Buea',
    spot: 'University of Buea gate',
    ago: '2 d ago',
    finder: 'Collins Ndi',
    tel: '670 31 18 94',
    q: 'Too dark: retake advised',
    consent: [true, true, true],
    d: {
      name: 'Sylvie Mbella',
      num: '1018 2231 4470',
      dob: '17 Jun 1999',
      addr: 'Molyko, Buea'
    }
  },
  {
    id: 6,
    type: 'other',
    town: 'Yaoundé',
    spot: 'Ngoa-Ekélé',
    ago: '3 d ago',
    finder: 'Aïcha Bello',
    tel: '655 78 02 41',
    q: 'Sharp',
    consent: [true, true, true],
    d: {
      name: 'Pierre Lontsi',
      num: 'UY1-22-0931',
      dob: '05 Nov 2002',
      addr: 'Ngoa-Ekélé'
    }
  }
]

export const INITIAL_CLAIMS: Claim[] = [
  {
    id: 1,
    type: 'id',
    town: 'Douala',
    who: 'Kevin Nkeng',
    tel: '677 98 10 22',
    ago: '12 min ago',
    ques: 'Which town issued your card?',
    exp: 'Douala',
    got: 'Douala',
    m: true,
    idp: true,
    risk: 'Low',
    st: 'new',
    sig: ['Name matches document', 'Answer matches', 'ID photo attached'],
    msgs: [['u', 'Hello, I lost my ID card last Friday in a taxi.']],
    d: {
      name: 'Kevin Nkeng',
      num: '1020 4457 8812',
      dob: '12 Mar 1996',
      addr: 'Bonanjo'
    }
  },
  {
    id: 2,
    type: 'pass',
    town: 'Yaoundé',
    who: 'Marie Tchoua',
    tel: '690 21 77 03',
    ago: '1 h ago',
    ques: 'What is your date of birth?',
    exp: '04 Aug 1991',
    got: '14 Aug 1991',
    m: false,
    idp: false,
    risk: 'High',
    st: 'new',
    sig: ['Answer is close but wrong', 'No ID photo attached', 'Same phone number claimed 2 other documents'],
    msgs: [['u', 'That passport is mine, please call me.']],
    d: {
      name: 'Marie Tchoua',
      num: 'CE 0481 2290',
      dob: '04 Aug 1991',
      addr: 'Bastos'
    }
  },
  {
    id: 3,
    type: 'birth',
    town: 'Bafoussam',
    who: 'Emmanuel Abena',
    tel: '651 02 45 90',
    ago: '3 h ago',
    ques: 'What is your mother’s first name?',
    exp: 'Rosine',
    got: 'Rosine',
    m: true,
    idp: true,
    risk: 'Low',
    st: 'new',
    sig: ['Answer matches', 'ID photo attached'],
    msgs: [['u', 'I need this for my university file.']],
    d: {
      name: 'Emmanuel Abena',
      num: 'N° 2209/2001',
      dob: '22 Jan 2001',
      addr: 'Bafoussam II'
    }
  },
  {
    id: 4,
    type: 'lic',
    town: 'Douala',
    who: 'Felix Bella',
    tel: '699 17 30 55',
    ago: '5 h ago',
    ques: 'Which date is printed as the issue date?',
    exp: '09 Feb 2021',
    got: '9/2/2021',
    m: true,
    idp: false,
    risk: 'Medium',
    st: 'new',
    sig: ['Answer matches (different format)', 'No ID photo attached'],
    msgs: [['u', 'Is it at the ferry quay office?']],
    d: {
      name: 'Felix Bella',
      num: 'PC 77 301 884',
      dob: '30 Sep 1988',
      addr: 'Bonabéri'
    }
  }
]

export const INITIAL_LISTINGS: Listing[] = [
  { id: 101, type: 'id', town: 'Douala', days: 2, st: 'Live', views: 84, cl: 1 },
  { id: 102, type: 'pass', town: 'Yaoundé', days: 4, st: 'Live', views: 61, cl: 1 },
  { id: 103, type: 'birth', town: 'Bafoussam', days: 9, st: 'Live', views: 27, cl: 1 },
  { id: 104, type: 'lic', town: 'Douala', days: 12, st: 'Live', views: 40, cl: 1 },
  { id: 105, type: 'id', town: 'Garoua', days: 16, st: 'Live', views: 33, cl: 0 },
  { id: 106, type: 'birth', town: 'Bamenda', days: 26, st: 'Live', views: 18, cl: 0 },
  { id: 107, type: 'id', town: 'Buea', days: 31, st: 'Recovered', views: 96, cl: 1 },
  { id: 108, type: 'pass', town: 'Douala', days: 40, st: 'Archived', views: 12, cl: 0 }
]

export const INITIAL_FRAUD_REPORTS: FraudReport[] = [
  {
    id: 1,
    who: 'Marie Tchoua',
    why: 'Wrong birth date in proof, no ID photo, and the same number claimed 2 other documents this week.',
    by: 'Automatic rule',
    sev: 'High',
    st: 'open'
  },
  {
    id: 2,
    who: 'Unknown claimant (+237 655 ••• 41)',
    why: 'Finder reported being asked to hand over a document outside the platform.',
    by: 'Finder report',
    sev: 'Medium',
    st: 'open'
  },
  {
    id: 3,
    who: 'Duplicate account: R. Fotso',
    why: 'Two accounts sharing one phone number, both claiming passports.',
    by: 'Automatic rule',
    sev: 'Low',
    st: 'open'
  }
]

export const INITIAL_AUDIT_EVENTS: AuditEvent[] = [
  { t: '09:12', w: 'Admin Antony approved listing: ID card · Douala', s: 0 },
  { t: '09:05', w: 'Admin Antony revealed an original document photo (reason: redaction)', s: 1 },
  { t: 'Yesterday', w: 'Admin Antony verified claim and scheduled handoff: Birth certificate · Bafoussam', s: 0 },
  { t: 'Yesterday', w: 'System archived 2 listings after 30 days of inactivity', s: 0 }
]

export const INITIAL_SETTINGS: ModerationSettings = {
  proof: true,
  phone: true,
  sms: true,
  reveal: true,
  days: 30,
  retain: 30
}
