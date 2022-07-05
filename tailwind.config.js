/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/es6/**/*.bs.js"],
  theme: {
    extend: {
      colors: {
        "radiola-red": "#EC343A",
        "radiola-purple": "#3F3981",
        "radiola-blue": "#152E4D",
        "radiola-light-grey": "#F9FBFD",
      },
      fontFamily: {
        cerebri: ["Cerebri Sans", "sans-serif"],
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
