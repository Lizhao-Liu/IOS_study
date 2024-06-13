import { defineConfig } from 'dumi';
import { networkInterfaces } from 'os';
import { join } from 'path';

const DIST = {
  dev: 'deploy-dev',
  beta: 'deploy-beta',
  prod: 'deploy-prod',
}

const deployEnv = process.env.NODE_ENV === 'development' ? 'dev' : process.env.DEPLOY_ENV || ('prod' as string)
const publicPath = '/fta-tiga/'
export default defineConfig({
  /**
   * 此处置为false是为了解决升级到 dumi2 后，文档运行时 type error 报错
   * 参考 github issue @see https://github.com/umijs/dumi/pull/1593
   */
  mfsu: false,
  publicPath,
  headScripts: [`window.publicPath = window.resourceBaseUrl || "${publicPath}";`],
  outputPath: DIST[deployEnv],
  base: publicPath,
  apiParser: {},
  resolve: {
    entryFile: './packages/docs/entry.ts',
  },
  favicons: ['https://imagecdn.ymm56.com/ymmfile/static/image/fta-view-ico.png'],
  /**
   * Hash history dumi2 目前不支持，改为使用默认 browser history @see https://github.com/umijs/dumi/issues/1553
   */
  // history: {
  //   type: 'hash',
  // },
  copy: ['examples/weui.h5.css', 'assets/style.css'],
  // plugins: ['@fta/plugins-assets', './dumi-plugins/taro'],
  plugins: ['./dumi-plugins/taro'],
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
  // assetsConfig: {
  //   projectName: 'fta-tiga',
  //   userName: '程志国',
  //   jobId: 'A1024370',
  //   groupId: '623151727da6bd00c56729d5', // 物料的所属组id，请 @章启成 获取
  //   previewUrl: 'https://fta.amh-group.com/view', // 物料的预览地址，上传物料时会自动截图上传，作为物料的封面图
  //   gitlabUrl: 'https://code.amh-group.com/MBFrontend/fta-apis',
  //   platform: 'fta',
  //   framework: 'mobile',
  // },

  locales: [{ id: 'zh-CN', name: '中文' }], // 2.0 默认值
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
    '@tarojs/components$': '@tarojs/components/dist-h5/react',
    '@tarojs/taro$': '@tarojs/taro-h5',
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
  exportStatic: false,
  themeConfig: {
    title: 'Tiga',
    description: '满帮跨平台原子 API 集合，支持跨端应用开发',
    lastUpdated: true,
    logo: 'https://imagecdn.ymm56.com/ymmfile/static/image/family/FTA_Workstation_Logo.png?x-oss-process=image/quality,q_1/resize,m_mfit,w_250',
    actions: [
      {
        text: '快速接入',
        type: 'primary',
        link: '/tutorial/quickstart',
      },
    ],
    features:[
      {
        title: '多端统一',
        details:
          '支持Web、Thresh、微信小程序、头条小程序等多个应用平台'
      },
      {
        title: 'API丰富',
        details:
          '提供一套丰富而完善的原子化 API, 助力开发者轻松构建各类应用场景'
      },
      {
        title: '按环境拆包',
        details: '根据环境拆分代码包，极致优化代码体积，为用户提供更快速、流畅的应用体验'
      }
    ],
    moreLinks: [
      {
        text: 'Taro',
        link: 'https://taro-docs.jd.com/docs/apis/about/desc'
      }
    ],
    deviceWidth: 360,
    webpack5: {},
    mfsu: false,
    rtl: false,
    // 配置高清方案，默认为 750 高清方案
    hd: {
      rules: []
    },

    nav: {
      mode: 'override',
      /** 此处指定导航栏【API】入口是为了解决不指定的话点击出现入口页面 not found 报错 */
      value: [
        {
          title: '更新日志',
          link: '/overview/changelog',
        },
        {
          title: '指南',
          link: '/tutorial/quickstart',
        },
        {
          title: 'API',
          link: '/tiga/caniuse/intro',
        },
        {
          title: 'GitLab',
          link: 'https://code.amh-group.com/MBFrontend/fta-apis',
        }
      ]
    },
    theme: {
      token: { colorPrimary: '#4eabfb' },
    },
  },
});


function packagePath(params: string) {
  return join(process.cwd(), 'packages', params)
}

function getLocalIP() {
  const nets = networkInterfaces()
  for (const name of Object.keys(nets)) {
    for (const net of nets[name]!) {
      if (net.family === 'IPv4' && !net.internal && net.address !== '127.0.0.1') {
        return net.address
      }
    }
  }
}
