module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {},
  },
  variants: {
    fontSize: ['responsive', 'hover', 'focus'],
  },
  plugins: [],
}