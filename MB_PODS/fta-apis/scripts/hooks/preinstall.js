const { resolve } = require('path')
const fs = require('fs')
const os = require('os')
const cwd = process.cwd()
const pkgPath = resolve(cwd, './package.json')
const pkg = require(pkgPath)

function preinstall() {
  delete pkg.dependencies
  delete pkg.devDependencies
  delete pkg.workspaces
  if (os.type() === 'Linux') {
    fs.writeFileSync(pkgPath, JSON.stringify(pkg))
  }
}

// preinstall()
