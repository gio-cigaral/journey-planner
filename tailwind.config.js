/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/es6/**/*.bs.js"],
  theme: {
    extend: {
      colors: {
        "custom-red": "#EC343A",
        "custom-purple": "#3F3981",
        "custom-blue": "#152E4D",
        "custom-light-grey": "#F9FBFD",
      },
      fontFamily: {
        cerebri: ["Cerebri Sans", "sans-serif"],
      }
    },
  },
  variants: {
    extend: {
      display: ["group-hover"],
    },
  },
  plugins: [],
}
