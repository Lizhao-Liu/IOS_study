import { defineConfig } from 'dumi'
import { networkInterfaces } from 'os'
import { join } from 'path'

const DIST = {
  dev: 'deploy-dev',
  beta: 'deploy-beta',
  prod: 'deploy-prod',
}

const deployEnv = process.env.DEPLOY_ENV

export default defineConfig({
  title: 'fta-tiga',
  favicon: 'https://imagecdn.ymm56.com/ymmfile/static/image/fta-view-ico.png',
  logo: 'https://imagecdn.ymm56.com/ymmfile/static/image/fta-view-logo1.png?x-oss-process=image/quality,q_1/resize,m_mfit,w_250',
  outputPath: DIST[deployEnv],
  publicPath: './',
  webpack5: {},
  history: { type: 'hash' },
  esbuild: {},
  copy: ['examples/weui.h5.css', 'assets/style.css'],
  plugins: ['@fta/plugins-assets', './dumi-plugins/taro'],
  // 涉及 taro-h5 demo 展示的收归到插件中
  taro: {
    enable: true,
    pxtoremIncludes: [
      packagePath('components'),
      packagePath('../examples/components'),
      packagePath('../node_modules/@tarojs/components'),
      packagePath('../node_modules/@fta/components'),
      join(process.cwd(), 'components', 'layout'),
    ],
  },
  // 物料上传的插件 @章启成
  assetsConfig: {
    projectName: 'fta-tiga',
    userName: '程志国',
    jobId: 'A1024370',
    groupId: '623151727da6bd00c56729d5', // 物料的所属组id，请 @章启成 获取
    previewUrl: 'https://fta.amh-group.com/view', // 物料的预览地址，上传物料时会自动截图上传，作为物料的封面图
    gitlabUrl: 'https://code.amh-group.com/MBFrontend/fta-apis',
    platform: 'fta',
    framework: 'mobile',
  },
  locales: [['zh-CN', '中文']],
  mode: 'site',
  navs: [
    {
      title: '介绍',
      path: '/overview',
    },
    {
      title: '快速接入',
      path: '/tutorial',
    },
    {
      title: 'API',
      path: '/components',
    },
    {
      title: 'GitLab',
      path: `//code.amh-group.com/MBFrontend/fta-apis`,
    },
  ],
  themeConfig: {
    hd: {
      rules: [],
    },
  },
  links: [
    {
      rel: 'stylesheet',
      href: 'https://imagecdn.ymm56.com/ymmfile/static/resource/a0ad360e-68b3-4025-89d9-3a7c5f892a12.css',
    },
    {
      rel: 'stylesheet',
      // TODO: 发布路径
      href: './style.css',
    },
  ],
  alias: {
    '@examples': join(process.cwd(), 'examples'),
    '@packages': join(process.cwd(), 'packages'),
    '@components': join(process.cwd(), 'components'),
    '@common': join(process.cwd(), 'common'),
    '@assets': join(process.cwd(), 'assets'),
  },
  define: {
    'process.env.LOCAL_IP': getLocalIP(),
  },
  chainWebpack(config) {
    config.resolve.mainFields.clear().add('main:h5').add('browser').add('module').add('main')
    config.module.rule('mjs-rule').test(/.m?js/).resolve.set('fullySpecified', false)
  },
})

function packagePath(params: string) {
  return join(process.cwd(), 'packages', params)
}

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
