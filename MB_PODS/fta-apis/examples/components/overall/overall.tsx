/**
 * hideActions: ["CSB"]
 * title: '组件总览'
 * defaultShowCode: false
 */

// @ts-ignore
import overview from '@assets/overview.json'
import { List, ListItem, SafeArea } from '@fta/components'
import { inRN, inWeapp, inWeb, useCareClass } from '@fta/components/common'
import { DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import { Image, View } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React, { useEffect } from 'react'
import { checkUpdate } from './check-update'
import './overall.scss'

/**
 * 组件总揽
 */
export default function Overall(): JSX.Element {
  useEffect(() => {
    if (inWeapp) checkUpdate()
  })
  return (
    <Layout
      showLeft={false}
      className='demo-overall'
      title='Tiga 总览'
      qrcode='components/overall/overall'>
      <View className='demo-overall-container'>
        <Intro />
        <FTAList />
      </View>
      <SafeArea />
      {/* 底栏 */}
      {/* <View className='demo-overall-tab-bar'></View> */}
    </Layout>
  )
}
/**
 * 组件介绍
 */
function Intro(): JSX.Element {
  // const [titleClz, subClz, descClz] = useCareClasses(
  //   ['demo-overall-title__text'],
  //   ['demo-overall-title__desc'],
  //   ['demo-overall-desc__text']
  // )
  const imageClz = useCareClass.single('demo-overall-intro-image')
  return (
    <View className='demo-overall-intro'>
      {/* <View className='demo-overall-title-container'>
        <Image
          className='demo-overall-logo'
          src='https://imagecdn.ymm56.com/ymmfile/static/resource/5928d681-ffdc-41b2-ae56-3804ebfe0a65.png'
          mode='aspectFit'
        />
        <View className='demo-overall-title'>
          <Text className={titleClz}>FTA View</Text>
          <Text className={subClz}>满帮大前端跨平台开发框架</Text>
        </View>
      </View>
      <View className='demo-overall-desc'>
        <Text className={descClz}>
          众多组件覆盖开发过程的各个需求，组件功能丰富，多端兼容。让你快速集成，开箱即用
        </Text>

      </View> */}
      <Image
        className={imageClz}
        mode='widthFix'
        src='https://imagecdn.ymm56.com/ymmfile/static/resource/fbb51bce-9c9d-4158-9404-277e7974841b.png'
      />
    </View>
  )
}

const hydrate = (str: string) =>
  str[0].toLowerCase() + str.slice(1).replace(/[A-Z]/g, (v) => `-${v.toLowerCase()}`)

const inFTAView = process.env.TARO_ENV_RUNTIME === 'h5'

function onItemClick(
  item: {
    name: string
    remark: string
    author: string | string[]
    cross: boolean
    snapshot: string
    demos: any[]
  },
  type: string,
  module?: string,
  context?: any
) {
  const name = hydrate(item.name)
  if (module) {
    module = hydrate(module as string)
  }
  jumpToPage(name, type, module, context)
}

function jumpToPage(name: string, type: string, module?: string, context?: any) {
  console.log(`/components/${type}/${module}/${name}/index` + context)
  if (inWeb && inFTAView) {
    // location.href = location.origin + `/#/~demos/${type}-${name}`
    module
      ? window.open(location.origin + location.pathname + `#/~demos/${module}-${name}`, '_self')
      : window.open(location.origin + location.pathname + `#/~demos/${type}-${name}`, '_self')
  } else {
    module
      ? Taro.navigateTo({
          url: `/components/${type}/${module}/${name}/index`,
          context,
        })
      : Taro.navigateTo({
          url: `/components/${type}/${name}/index`,
          context,
        })
  }
}

/**
 * 在RN端只显示跨端组件
 */
function filter(list: any[]) {
  return list.filter((v) => v.done !== false && (inRN ? v.support?.includes('rn') : true))
}

/**
 * 渲染组件列表
 */
function FTAList(): JSX.Element {
  const tigaModules = overview.components.tiga.list as any[] // 从 overview.json 中读取 tiga module
  const textClz = useCareClass(['demo-overall-components__text'])
  const context = useThreshContext()
  return (
    <View className='demo-overall-list'>
      {/* {Object.entries(components).map(([name, v], index) => (
        <View key={name} className='demo-overall-components'>
          <Text className={textClz}>{v.name}</Text>
          <List>
            {filter(v.list).map((item: any, i: number) => (
              <ListItem
                onClick={() => onItemClick(item, name, context)}
                key={i}
                title={`${item.name} ${item.remark}`}
                arrow
                thumb={item.thumb || fallbackThumb}
              />
            ))}
          </List>
        </View>
      ))} */}
      {tigaModules.map((module: any, index) => (
        // <View key={module.name} className='demo-overall-components'>
        <DemoBlock label={`${module.name} ${module.remark}`} pure>
          {/* <Text className={textClz}>{module.name}</Text>
          <Text className={textClz}>test</Text> */}
          {module.demos && module.demos.length > 0 ? (
            <List>
              {filter(module.demos).map((item: any, i: number) => (
                <ListItem
                  onClick={() => onItemClick(item, 'tiga', module.name, context)}
                  key={i}
                  title={`${item.remark}`}
                  arrow
                />
              ))}
            </List>
          ) : (
            <List>
              <ListItem
                onClick={() => onItemClick(module, 'tiga', undefined, context)}
                key={'tiga'}
                title={`${module.remark}`}
                arrow
              />
            </List>
          )}
        </DemoBlock>
      ))}
    </View>
  )
}
