// TODO: Uncomment tailwindcss/colors upon upgrading to Tailwind 2
// const colors = require('tailwindcss/colors')
const { colors } = require('tailwindcss/defaultTheme')

module.exports = {
  theme: {
    extend: {
      colors: {
        primary: colors.purple,
        neutral: colors.gray,
      },
    },
  },
  plugins: [
    require('@tailwindcss/ui'),
  ]
}
