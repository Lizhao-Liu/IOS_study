const fs = require('fs')
const path = require('path')
const project = path.join(__dirname, '../tsconfig.json')

require('ts-node').register({ project })

const create = require('./creat-components.ts')

create()
