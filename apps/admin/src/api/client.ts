/**
 * Doc-Find Admin Dashboard - API Client
 *
 * Provides typed HTTP methods to connect the Pinia stores to the FastAPI backend (`/api/v1`).
 * Handles JWT Bearer authentication headers and error formatting.
 */

const BASE_URL = import.meta.env.VITE_API_URL || '/api/v1'

export interface ApiError {
  detail: string
  status: number
}

class ApiClient {
  private token: string | null = null

  constructor() {
    this.token = localStorage.getItem('docfind_admin_token')
  }

  setToken(token: string | null) {
    this.token = token
    if (token) {
      localStorage.setItem('docfind_admin_token', token)
    } else {
      localStorage.removeItem('docfind_admin_token')
    }
  }

  getToken(): string | null {
    return this.token
  }

  private getHeaders(): HeadersInit {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    }
    if (this.token) {
      headers.Authorization = `Bearer ${this.token}`
    }
    return headers
  }

  async request<T>(path: string, options: RequestInit = {}): Promise<T> {
    const url = `${BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
    const response = await fetch(url, {
      ...options,
      headers: {
        ...this.getHeaders(),
        ...(options.headers || {}),
      },
    })

    if (!response.ok) {
      let detail = 'An unexpected server error occurred'
      try {
        const errorJson = await response.json()
        detail = errorJson.detail || detail
      } catch {
        // use fallback text
      }
      const err: ApiError = {
        detail,
        status: response.status,
      }
      throw err
    }

    if (response.status === 204) {
      return {} as T
    }

    return response.json() as Promise<T>
  }

  get<T>(path: string): Promise<T> {
    return this.request<T>(path, { method: 'GET' })
  }

  post<T>(path: string, body?: unknown): Promise<T> {
    return this.request<T>(path, {
      method: 'POST',
      body: body ? JSON.stringify(body) : undefined,
    })
  }

  patch<T>(path: string, body?: unknown): Promise<T> {
    return this.request<T>(path, {
      method: 'PATCH',
      body: body ? JSON.stringify(body) : undefined,
    })
  }

  delete<T>(path: string): Promise<T> {
    return this.request<T>(path, { method: 'DELETE' })
  }
}

export const apiClient = new ApiClient()
