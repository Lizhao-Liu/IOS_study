// import * as pxtorem from '@fta/plugins-postcss-dumi'
import pxtorem from '@fta/plugins-postcss-dumi';
import TaroApi from 'babel-plugin-transform-taroapi';
import { merge } from 'lodash';
import apis from './taroApis';
// import { IApi } from 'umi'
import { IApi } from 'dumi';

// /**
//  * TaroApi 构建 H5 应用时 走的插件
//  * 将 taro 的 api 转换为 taro-h5 的 api
//  * babel 插件需要读取 apis 的 Set 配置
//  * 但是 umi config 编译有问题
//  * 遂手动实现最简版
//  * */
// const getApi = {
//   has: function (api: string) {
//     return _apis.includes(api)
//   },
// }

interface TaroConfig {
  enable: boolean
  // 有 哪些组件需要去编译 px
  pxtoremIncludes: string[]
}

module.exports = function (api: IApi) {
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

  const { enable = false, pxtoremIncludes = [] } = api.userConfig.taro as TaroConfig
  if (!enable) return

  // 注册 webcomponent
  api.addEntryCode(() => {
    return `
import { defineCustomElements } from '@tarojs/components/loader/index.cjs.js'
defineCustomElements(window)`
  })

  // 非常奇怪的一个点，通过 mergeConfig 无法注入新的 html style
  api.addHTMLStyles(() => {
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
  api.modifyConfig((memo) => {
    const config = merge(memo, {
      // polyfill: {
      //   imports: ['core-js/stable'],
      // },
      extraPostCSSPlugins: [
        pxtorem({
          platform: 'h5',
          designWidth: 750,
          includes: ['taro-ui', '@tarojs/components', ...pxtoremIncludes],
        }),
      ],
      extraBabelPlugins: [
        [
          TaroApi,
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
const getApi = {
  has: function (api: string) {
    // console.log("apis type: ", typeof(apis))
    // console.log("apis type: ", typeof(Object.values(apis)))
    const _apis = Array.from(apis)
    // console.log("_apis: ", _apis)
    return _apis.includes(api)
  },
}
