const networkInterfaces = require('os').networkInterfaces

function getLocalIP() {
  const nets = networkInterfaces()
  for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
      if (net.family === 'IPv4' && !net.internal && net.address !== '127.0.0.1') {
        return net.address
      }
    }
  }
}

const includesFta = (chain) => {
  const whiteList = ['@fta', '@tarojs']
  const isIncludeFile = filename =>whiteList.some(it => filename.includes(it))

  /**
   * include js/ts 等文件，适用各端。
   */
  const scriptExclude = chain.module.rules.get('script').exclude
  const _scriptExcludeValues = scriptExclude.values()
  scriptExclude.clear().add(filename => {
    if (isIncludeFile(filename)) {
      return false
    }
    return _scriptExcludeValues.some(it => it.call(null, filename))
  })

  const cssIncludesFta = () => {
    const postcssExclude = chain.module.rules.get('postcss').exclude
      const _postcssExcludeValues = postcssExclude.values()
      postcssExclude.clear().add(filename => {
        if (isIncludeFile(filename)) {
          return false
        }
        return _postcssExcludeValues.some(it => it.call(null, filename))
      })
  }

  return {
    mini: () => {
      chain.resolve.plugin('MultiPlatformPlugin').tap((args) => {
        const [a, b, options] = args

        options.include = ['@fta']
        return [a, b, options]
      })
    },
    h5: () => {
      cssIncludesFta()
    },
    mw: () => {
      cssIncludesFta()
    },
    rn: () => {
      const postcssExclude = chain.module.rules.get('postcss').exclude
      const _postcssExcludeValues = postcssExclude.values()
      postcssExclude.clear().add(filename => {
        if (isIncludeFile(filename)) {
          return false
        }
        return _postcssExcludeValues.some(it => it.call(null, filename))
      })
    }
  }
}

exports.getLocalIP = getLocalIP

exports.includesFta = includesFta
