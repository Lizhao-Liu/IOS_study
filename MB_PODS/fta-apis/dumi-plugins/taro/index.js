'use strict'
let __spreadArray =
  (this && this.__spreadArray) ||
  function (to, from, pack) {
    if (pack || arguments.length === 2)
      for (let i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
          if (!ar) ar = Array.prototype.slice.call(from, 0, i)
          ar[i] = from[i]
        }
      }
    return to.concat(ar || Array.prototype.slice.call(from))
  }
exports.__esModule = true
let pxtorem = require('@fta/plugins-postcss-dumi')
let apis = require('@tarojs/taro-h5/dist/taroApis')
let babel_plugin_transform_taroapi_1 = require('babel-plugin-transform-taroapi')
let lodash_1 = require('lodash')
module.exports = function (api) {
  api.describe({
    key: 'taro',
    config: {
      schema: function (Joi) {
        return Joi.object({
          enable: Joi.boolean(),
          pxtoremIncludes: Joi.any(),
        })
      },
    },
  })
  let _a = api.userConfig.taro,
    _b = _a.enable,
    enable = _b === void 0 ? false : _b,
    _c = _a.pxtoremIncludes,
    pxtoremIncludes = _c === void 0 ? [] : _c
  if (!enable) return
  // 注册 webcomponent
  api.addEntryCode(function () {
    return "\nimport { defineCustomElements } from '@tarojs/components/loader/index.cjs.js'\ndefineCustomElements(window)"
  })
  // 非常奇怪的一个点，通过 mergeConfig 无法注入新的 html style
  api.addHTMLStyles(function () {
    return [
      {
        content:
          'html.hydrated{font-size: calc(100vw/375 * 23.4375)}.__dumi-default-mobile-demo-layout{padding: 0 !important}@media only screen and (min-width: 640px){html.hydrated{font-size: 40px}}@media only screen and (max-width: 320px){html.hydrated{font-size: 20px}}',
      },
    ]
  })
  /**
   * 转换 px 单位， 及 taro api 替换
   */
  api.modifyConfig(function (memo) {
    let config = (0, lodash_1.merge)(memo, {
      // polyfill: {
      //   imports: ['core-js/stable'],
      // },
      extraPostCSSPlugins: [
        pxtorem({
          platform: 'h5',
          designWidth: 750,
          includes: __spreadArray(['taro-ui', '@tarojs/components'], pxtoremIncludes, true),
        }),
      ],
      extraBabelPlugins: [
        [
          babel_plugin_transform_taroapi_1['default'],
          {
            packageName: '@tarojs/taro',
            apis: getApi,
          },
        ],
      ],
      // 组件引用映射到 h5
      alias: {
        '@tarojs/components$': '@tarojs/components/dist-h5/react',
        '@tarojs/taro$': '@tarojs/taro-h5',
      },
      // 用于 taro 平台区分 的环境变量
      define: {
        ENABLE_INNER_HTML: true,
        ENABLE_ADJACENT_HTML: true,
        ENABLE_SIZE_APIS: true,
        'process.env.TARO_ENV': 'h5',
        'process.env.TARO_ENV_RUNTIME': 'h5',
      },
    })
    return config
  })
}
/**
 * TaroApi 构建 H5 应用时 走的插件
 * 将 taro 的 api 转换为 taro-h5 的 api
 * babel 插件需要读取 apis 的 Set 配置
 * 但是 umi config 编译有问题
 * 遂手动实现最简版
 * */
let getApi = {
  has: function (api) {
    // let _apis = Array.from(apis)
    // return _apis.includes(api)
    return true
  },
}
