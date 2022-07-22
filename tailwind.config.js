// tailwind.config.js

module.exports = {
  content: [
    './app/components/**/*.html.erb',
    './app/components/**/*.rb',
    './app/views/**/*.html.erb',
    './app/packs/stylesheets/*.scss',
    './app/helpers/**/*.rb'
  ],
  theme: {
    extend: {
      colors: {
        primary: 'var(--color-primary)'
      }
    }
  },
  variants: {},
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
  corePlugins: {
    // Disabled here and added with scope in _container.scss
    container: false,
    preflight: false
  }
}
