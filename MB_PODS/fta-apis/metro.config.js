/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */
const path = require('path')

// 由于 lerna 会将 packages 目录下的包链接到 node_modules 目录下，所以这里需要额外配置，否则 metro 无法找到包
const extraNodeModules = {}

module.exports = {
  resetCache: true,
  resolver: {
    extraNodeModules,
  },
}
