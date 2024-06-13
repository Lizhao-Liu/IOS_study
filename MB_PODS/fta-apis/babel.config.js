// babel-preset-taro 更多选项和默认值：
// https://github.com/NervJS/taro/blob/next/packages/babel-preset-taro/README.md
const transform = require('@fta/components/babel-import')
let presets = []
let plugins = [
  [
    '@peterczg/babel-plugin-transform-imports',
    {
      '@fta/components': {
        transform,
        preventFullImport: true,
      },
    },
  ],
  ['@babel/plugin-proposal-export-namespace-from'],
]

if (process.env.TARO_ENV) {
  if (process.env.TARO_ENV == 'rn') {
    plugins = ['@babel/plugin-proposal-export-namespace-from']
    presets = [
      [
        '@fta/babel-preset-taro-rn',
        {
          framework: 'react',
          ts: true,
          reactJsxRuntime: 'classic', // TODO: 使用 jsx/runtime
        },
      ],
    ]
  } else if (process.env.TARO_ENV == 'thresh') {
    plugins = ['@babel/plugin-proposal-export-namespace-from']
    presets = [
      [
        '@fta/babel-preset-taro-thresh',
        {
          framework: 'react',
          ts: true,
          reactJsxRuntime: 'classic', // TODO: 使用 jsx/runtime
          priorityUseTigaAPI: true,
        },
      ],
    ]
  } else if (process.env.IS_MW) {
    plugins = ['@babel/plugin-proposal-export-namespace-from']
    presets = [
      [
        '@fta/babel-preset-taro-h5',
        {
          framework: 'react',
          ts: true,
          reactJsxRuntime: 'classic', // TODO: 使用 jsx/runtime
          priorityUseTigaAPI: true,
        },
      ],
    ]
  } else {
    presets = [
      [
        'taro',
        {
          framework: 'react',
          ts: true,
          reactJsxRuntime: 'classic',
        },
      ],
    ]
  }
}

module.exports = {
  presets,
  plugins,
}
