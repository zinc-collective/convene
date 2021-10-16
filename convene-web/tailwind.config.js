// TODO: Uncomment tailwindcss/colors upon upgrading to Tailwind 2
// const colors = require('tailwindcss/colors')
const { colors } = require('tailwindcss/defaultTheme')

module.exports = {
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
  ]
}
