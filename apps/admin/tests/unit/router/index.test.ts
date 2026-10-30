import { describe, it, expect } from 'vitest'
import { router, routes } from '../../../src/router'

describe('router', () => {
  it('defines all required routes', () => {
    const routeNames = routes.map((r) => r.name).filter(Boolean)
    expect(routeNames).toContain('overview')
    expect(routeNames).toContain('queue')
    expect(routeNames).toContain('claims')
    expect(routeNames).toContain('listings')
    expect(routeNames).toContain('fraud')
    expect(routeNames).toContain('audit')
    expect(routeNames).toContain('settings')
  })

  it('updates document.title on navigation', async () => {
    await router.push('/claims')
    expect(document.title).toContain('Claims')

    await router.push('/queue')
    expect(document.title).toContain('Review queue')
  })
})
