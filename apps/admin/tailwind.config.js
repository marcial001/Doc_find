/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  darkMode: ['selector', '[data-theme="dark"]'],
  theme: {
    extend: {
      spacing: {
        '4.5': '1.125rem', // 18px matching design token
      },
      colors: {
        bg: 'var(--bg)',
        surf: 'var(--surf)',
        ink: 'var(--ink)',
        mute: 'var(--mute)',
        g: 'var(--g)',
        g2: 'var(--g2)',
        sun: 'var(--sun)',
        red: {
          DEFAULT: 'var(--red)',
          tint: 'var(--red2)'
        },
        amb: {
          DEFAULT: 'var(--amb)',
          tint: 'var(--amb2)'
        },
        line: 'var(--line)',
        onG: 'var(--onG)',
        side: 'var(--side)',
        doc: {
          id: '#2E7D5B',
          pass: '#274C9B',
          birth: '#B4741C',
          lic: '#8A3AA3',
          other: '#5C6B63'
        }
      },
      fontFamily: {
        display: ['"Bricolage Grotesque"', 'Figtree', 'system-ui', 'sans-serif'],
        sans: ['Figtree', 'system-ui', 'sans-serif']
      }
    },
  },
  plugins: [],
}
