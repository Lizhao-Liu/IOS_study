const path = require('path')
const { getLocalIP, includesFta } = require('./utils')

const config = {
  projectName: 'fta-tiga-demo',
  env: {
    LOCAL_IP: `"${getLocalIP()}"`,
  },
  date: '2020-3-10',
  designWidth: 720,
  sass: {
    // resource: [path.resolve(__dirname, '../examples/app.scss')],
  },
  compiler: {
    type: 'webpack5',
    // 依赖预编译配置
    prebundle: {
      enable: true,
      timings: true,
      exclude: ['@fta/components', '@fta/apis-track', 'react', 'react-dom'],
    },
  },
  cache: {
    enable: true,
  },
  isWatch: process.env.NODE_ENV === 'development',
  deviceRatio: {
    320: 0.5,
    640: 2.34 / 2,
    720: 75 / 72,
    750: 1,
    828: 1.81 / 2,
  },
  sourceRoot: 'examples',
  outputRoot: `dist-${process.env.TARO_ENV}`,
  csso: {
    enable: true,
    config: {
      // 配置项同 https://github.com/css/csso#minifysource-options
    },
  },
  alias: {
    '@/': path.resolve(__dirname, '..', 'src'),
    '@fta/common': path.resolve(__dirname, '../node_modules/@fta/common'),
    '@fta/components/common': path.resolve(__dirname, '../node_modules/@fta/components/common'),
    '@fta/components$': path.resolve(__dirname, '../node_modules/@fta/components/index'),
    '@fta/theme': path.resolve(__dirname, '../node_modules/@fta/theme'),
    '~@fta/common': path.resolve(__dirname, '../node_modules/@fta/common'),
    '~@fta/theme': path.resolve(__dirname, '../node_modules/@fta/theme'),
    '~@fta/components': path.resolve(__dirname, '../node_modules/@fta/components'),
    '@examples': path.join(process.cwd(), 'examples'),
    '@components': path.join(process.cwd(), 'components'),
    '@assets': path.join(process.cwd(), 'assets'),
    // '@fta/components-car-keyboard/lib': path.join(process.cwd(), 'packages', 'car-keyboard', 'lib'),
  },
  framework: 'react',
  externals: {
    SwanSitemapList: 'dynamicLib://swan-sitemap-lib/swan-sitemap-list',
  },
  plugins: [
    '@fta/plugin-platform-amh-rn',
    '@fta/plugin-platform-thresh',
    '@fta/plugins-platform-mw',
  ],
  babel: {
    sourceMap: false,
    presets: [
      [
        'env',
        {
          modules: false,
        },
      ],
    ],
    plugins: [
      'transform-decorators-legacy',
      'transform-class-properties',
      'transform-object-rest-spread',
      'plugin-syntax-decorators',
      [
        'transform-runtime',
        {
          helpers: false,
          polyfill: false,
          regenerator: true,
          moduleName: 'babel-runtime',
        },
      ],
      [
        '@babel/plugin-proposal-class-properties',
        {
          loose: true,
        },
      ],
    ],
  },
  defineConstants: {},
  resolve: {
    include: '@fta',
  },
  mw: {
    mw: 'mirco-web',
    router: {
      mode: 'multi',
    },
    resolve: {
      include: ['@fta'],
    },
    postcss: {
      cssModules: {
        enable: true, // 默认为 false，如需使用 css modules 功能，则设为 true
        config: {
          namingPattern: 'module', // 转换模式，取值为 global/module
          generateScopedName: '[name]__[local]___[hash:base64:5]',
        },
      },
    },
    webpackChain: (chain, webpack) => {
      includesFta(chain).h5()
    },
  },
  mini: {
    postcss: {
      pxtransform: {
        enable: true,
        config: {},
      },
      url: {
        enable: true,
        config: {
          limit: 10240, // 设定转换尺寸上限
        },
      },
      cssModules: {
        enable: true, // 默认为 false，如需使用 css modules 功能，则设为 true
        config: {
          namingPattern: 'module', // 转换模式，取值为 global/module
          generateScopedName: '[name]__[local]___[hash:base64:5]',
        },
      },
    },
    webpackChain: (chain, webpack) => {
      chain.mode('production')
      chain.merge({
        plugin: {
          install: {
            plugin: require('terser-webpack-plugin'),
            args: [
              {
                terserOptions: {
                  compress: true, // 默认使用terser压缩
                  // mangle: false,
                  keep_classnames: true, // 不改变class名称
                  keep_fnames: true, // 不改变函数名称
                },
              },
            ],
          },
        },
      })

      includesFta(chain).mini()
    },
  },
  h5: {
    publicPath: '/',
    staticDirectory: 'static',
    postcss: {
      autoprefixer: {
        enable: true,
        config: {
          browsers: ['last 3 versions', 'Android >= 4.1', 'ios >= 8'],
        },
      },
      cssModules: {
        enable: false, // 默认为 false，如需使用 css modules 功能，则设为 true
        config: {
          namingPattern: 'module', // 转换模式，取值为 global/module
          generateScopedName: '[name]__[local]___[hash:base64:5]',
        },
      },
    },
    resolve: {
      include: ['@fta'],
    },
    webpackChain(chain, webpack) {
      includesFta(chain).h5()
    },
  },
  rn: {
    appName: 'index',
    output: {
      ios: './ios/main.jsbundle',
      iosAssetsDest: './ios',
      android: './android/app/src/main/assets/index.android.bundle',
      androidAssetsDest: './android/app/src/main/res',
      iosSourcemapOutput: './ios/main.map',
      androidSourcemapOutput: './android/app/src/main/assets/index.android.map',
    },
    postcss: {
      pxtransform: {
        enable: true,
        config: {},
      },
      cssModules: {
        enable: true,
      },
    },
    enableMultipleClassName: true,
    resolve: {
      include: ['@fta'],
    },
    nativeComponents: {
      externals: ['prop-types', 'classnames', '@fta/components'],
    },
  },
  thresh: {
    postcss: {
      cssModules: {
        enable: true, // 默认为 false，如需使用 css modules 功能，则设为 true
        config: {
          namingPattern: 'module', // 转换模式，取值为 global/module
          generateScopedName: '[name]__[local]___[hash:base64:5]',
          test: 1,
        },
      },
    },
    enableMultipleClassName: true,
    resolve: {
      include: ['@fta'],
    },
    nativeComponents: {
      externals: ['@fta'],
      output: 'dist-thresh-comp',
    },
  },
}

module.exports = function (merge) {
  return merge({}, config)
}
