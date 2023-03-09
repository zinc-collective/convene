const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/furniture/**/*.html.erb',
    './app/utilities/**/*.html.erb',
    './app/views/**/*.html.erb',

    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.purple,
        danger: colors.red,
        neutral: colors.gray,
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
  ],
}
