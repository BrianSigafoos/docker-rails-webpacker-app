import { Controller } from '@hotwired/stimulus'
import DevLog from './shared/DevLog'

const COLORS = ['pink', 'green', 'teal']
const DARK_SCHEME = 'dark'
const LIGHT_SCHEME = 'light'
const SCHEME_KEY = 'appScheme'
const COLOR_KEY = 'appColor'

export default class extends Controller {
  // Read from the getter and write that value to the setter.
  initialize() {
    this.appScheme = this.currentScheme
    this.appColor = this.currentColor
  }

  // Unlike initialize, calling toggle persists the change in localStorage
  toggleScheme(e) {
    e.preventDefault()

    let scheme = this.currentScheme === DARK_SCHEME ? LIGHT_SCHEME : DARK_SCHEME

    this.appScheme = scheme
    this.storeScheme = scheme
  }

  toggleColor(e) {
    e.preventDefault()

    let colorIndex = COLORS.findIndex((k) => k === this.currentColor)
    let color = COLORS[colorIndex + 1] || COLORS[0]

    this.appColor = color
    this.storeColor = color
  }

  // Private

  /* eslint-disable class-methods-use-this */
  set appScheme(val) {
    document.body.dataset.colorScheme = val
  }

  set appColor(val) {
    document.body.dataset.colorPrimary = val
  }

  set storeScheme(val) {
    localStorage.setItem(SCHEME_KEY, val)
  }

  set storeColor(val) {
    localStorage.setItem(COLOR_KEY, val)
  }

  // Check localStorage first for preference, then check OS.
  get currentScheme() {
    const fromLocal = localStorage.getItem(SCHEME_KEY)
    if (fromLocal) {
      DevLog(['Color scheme found in localStorage', fromLocal])
      return fromLocal
    }

    const darkFromOS = window.matchMedia('(prefers-color-scheme: dark)').matches
    if (darkFromOS) {
      DevLog(['Color scheme found at OS level as dark'])
      return DARK_SCHEME
    }

    // Default
    return LIGHT_SCHEME
  }

  // Check localStorage first for preference.
  get currentColor() {
    const fromLocal = localStorage.getItem(COLOR_KEY)
    if (fromLocal) {
      DevLog(['Color primary found in localStorage', fromLocal])
      return fromLocal
    }

    return COLORS[0]
  }
  /* eslint-enable class-methods-use-this */
}
