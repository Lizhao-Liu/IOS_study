import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'


export default () => {
  const context = useThreshContext()

  function push() {
    Tiga.Navigator.push({
      url: 'this:///components/tiga/navigator/index',
      flag: Tiga.Navigator.FLAG_KEEP_CONTAINER,
      context: context,
      onResult: (resultData) => {
        console.log('onResult', resultData)
        Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
      },
    })
  }
  function pushWithNewContainer() {
    Tiga.Navigator.push({
      url: 'this:///components/tiga/navigator/index',
      flag: Tiga.Navigator.FLAG_NEW_CONTAINER,
      context: context,
      onResult: (resultData) => {
        console.log('onResult', resultData)
        Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
      },
    })
      .then((result) => {
        console.log('fulfilled')
      })
      .catch((result) => {
        console.log(result)
      })
  }
  function pushAndClearTop() {
    Tiga.Navigator.push({
      url: 'this:///components/overall/overall',
      flag: Tiga.Navigator.FLAG_CLEAR_TOP,
      context: context,
    })
  }

  function navigateToIndex() {
    Taro.navigateTo({ url: '/components/tiga/navigator/index', context })
    .catch((err) => console.error(err))
  }

  function navigateToAlice() {
    Taro.navigateTo({ url: '/components/tiga/navigator/alice', context })
    .catch((err) => console.error(err))
  }

  return (
    <Layout title='Navigator' qrcode='components/tiga/navigator/push/index'>
      <DemoBlock label='使用Tiga方法进入新页面' pure>
        <List>
          <ListItem title='新页面使用新容器' arrow='right' onClick={push} />
          <ListItem title='新页面保持当前容器' arrow='right' onClick={pushWithNewContainer} />
          <ListItem title='推出栈顶页面直到已存在的目标页面回到栈顶' arrow='right' onClick={pushAndClearTop} />
        </List>
      </DemoBlock>
      <DemoBlock label='使用Taro方法进入新页面' pure>
        <List>
          <ListItem title='进入到index页面' arrow='right' onClick={navigateToIndex} />
          <ListItem title='进入到alice页面' arrow='right' onClick={navigateToAlice} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
