/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/es6/**/*.bs.js"],
  theme: {
    extend: {
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
