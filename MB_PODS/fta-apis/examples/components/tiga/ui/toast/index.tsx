/**
 * componentName: 'toast'
 * des: 'toast 提示'
 * previewUrl: 'components/tiga/ui/toast'
 * materialType: 'component'
 * package: '@fta/components-ui'
 */
import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()
  function showToast1() {
    Taro.showToast({
      title: '纯文本toast',
      icon: 'none',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showToast2() {
    Taro.showToast({
      title: '居上的toast, 仅app端内支持',
      gravity: 1,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showToast3() {
    Taro.showToast({
      title: '居下的toast, 仅app端内支持',
      gravity: 2,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showToast4() {
    Taro.showToast({
      title: '成功',
      icon: 'success',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showToast5() {
    Taro.showToast({
      title: '警告, 仅app内支持',
      icon: 'warning',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showToast6() {
    Taro.showToast({
      title: '失败',
      icon: 'error',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showToast7() {
    Taro.showToast({
      title: '自定义图标',
      image: 'https://imagecdn.ymm56.com/ymmfile/static/image/trade/success.png',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showToast8() {
    Taro.showToast({
      title: '左边图标,右边文本,仅app端内支持',
      icon: 'success',
      toastType: 1,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showToast10() {
    Taro.showToast({
      title: '3秒后自动隐藏',
      duration: 3000,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showToast11() {
    Taro.showToast({
      title: '1.5秒后自动隐藏',
      duration: 1500,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function hideToast() {
    Taro.hideToast({
      context,
    })
  }

  return (
    <Layout title='UI' qrcode='components/tiga/ui/toast/index'>
      <DemoBlock label='文字样式' pure>
        <List>
          <ListItem title='纯文本toast' arrow='right' onClick={showToast1} />
          <ListItem title='居上的toast, 仅app端内支持' arrow='right' onClick={showToast2} />
          <ListItem title='居下的toast, 仅app端内支持' arrow='right' onClick={showToast3} />
        </List>
      </DemoBlock>

      <DemoBlock label='图标样式' pure>
        <List>
          <ListItem title='成功' arrow='right' onClick={showToast4} />
          <ListItem title='警告' arrow='right' onClick={showToast5} />
          <ListItem title='失败' arrow='right' onClick={showToast6} />
          <ListItem title='自定义图标' arrow='right' onClick={showToast7} />
          <ListItem title='左边图标，右边文本, 仅app端内支持' arrow='right' onClick={showToast8} />
        </List>
      </DemoBlock>

      <DemoBlock label='自定义显示时长' pure>
        <List>
          <ListItem title='3秒后自动隐藏' arrow='right' onClick={showToast10} />
          <ListItem title='1.5秒后自动隐藏' arrow='right' onClick={showToast11} />
        </List>
      </DemoBlock>

      <DemoBlock label='隐藏toast' pure>
        <List>
          <ListItem title='隐藏toast' arrow='right' onClick={hideToast} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
