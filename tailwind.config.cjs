const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/furniture/**/*{_component.rb,.html.erb}',
    './app/utilities/**/*.html.erb',
    './app/views/**/*.html.erb',
    './app/components/**/*.{erb,rb}',
    './spec/components/previews/**/*.{erb,rb}',

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
