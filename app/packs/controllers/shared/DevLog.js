// Only shows log messages in development
// Always pass in an array of arguments
/* eslint-disable no-console, no-undef */
const DevLog = (args = []) => {
  if (process.env.RAILS_ENV === 'development') {
    console.log(...args)
  }
}
/* eslint-enable no-console, no-undef */

export default DevLog
