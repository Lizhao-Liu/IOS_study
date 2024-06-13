import React from 'react'
import './Platform.less'
import globalLogicIcon from './icons/global.svg'
import webviewIcon from './icons/webview.svg'

const platformMap = {
  mw: '微前端',
  rn: '满帮RN',
  h5: '端内h5',
  logic: 'global logic',
  weapp: '微信',
  alipay: '支付宝',
  toutiao: '字节',
  thresh: '满帮Thresh',
}

const sortMap: Record<keyof typeof platformMap, number> = {
  mw: 1,
  thresh: 2,
  rn: 3,
  h5: 4,
  logic: 5,
  weapp: 11,
  alipay: 12,
  toutiao: 13,
}

const imgMap: Record<keyof typeof platformMap, string> = {
  mw: webviewIcon,
  logic: globalLogicIcon,
  rn: 'https://imagecdn.ymm56.com/ymmfile/static/resource/cf7fa417-4a52-4504-b99f-a19461406dc2.png',
  weapp:
    'https://imagecdn.ymm56.com/ymmfile/static/resource/319df2f1-81b4-4fcf-9ef3-1f436b7eae78.png',
  alipay:
    'https://imagecdn.ymm56.com/ymmfile/static/resource/caf6e8ac-8d12-41db-8775-fc9e826044cc.png',
  toutiao:
    'https://imagecdn.ymm56.com/ymmfile/static/resource/a982ff59-5278-4f27-a974-decce8862df5.png',
  thresh:
    'https://imagecdn.ymm56.com/ymmfile/static/resource/8a4818dc-2651-4dea-9d51-a846dd25b69e.svg',
  h5: 'https://imagecdn.ymm56.com/ymmfile/static/resource/ca5fedaa-ac23-426c-8104-0a4713776c9b.png',
}

type Support = keyof typeof platformMap

interface PlatformProps {
  support?: Support
  version?: string
  name?: string
}

/**
 * API支持的平台 标签
 */
export default function Platform(props: PlatformProps) {
  let support = props.support?.split(',') || []
  if (props.name) {
    try {
      const module = require('../../../packages/tiga/' + props.name + '/package.json')
      console.log(module)
      support = module.platforms
    } catch (error) {
      console.log(error)
    }
  }
  support = support.sort((a, b) => (sortMap[a] || 0) - (sortMap[b] || 0))

  return (
    <section className='__dumi-default-platform'>
      {props.version ? (
        <span className='__dumi-default-platform-version'>Tiga SDK: {props.version}</span>
      ) : null}
      {support?.length
        ? support.map((s, i) => (
            <span key={i} className='__dumi-default-platform-item'>
              <img className='__dumi-default-platform-item__img' src={imgMap[s]} alt={s} />
              <span className='__dumi-default-platform-item__text'>{platformMap[s]}</span>
            </span>
          ))
        : null}
    </section>
  )
}
