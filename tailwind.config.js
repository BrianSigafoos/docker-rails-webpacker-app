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
    extend: {},
  },
  variants: {},
  plugins: [require('@tailwindcss/forms')],
}
