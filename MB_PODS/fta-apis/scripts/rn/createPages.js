const fs = require('fs-extra')
const path = require('path')

const pages = ['drivercerify', 'index']
function writePages(platform) {
  platform = platform || process.env.platform || 'ios'
  const dist = path.resolve(__dirname, `../../${platform}/pages.json`)

  fs.writeJSONSync(dist, pages)
}

writePages()

module.exports = writePages
