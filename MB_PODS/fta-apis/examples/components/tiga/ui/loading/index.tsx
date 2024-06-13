/**
 * componentName: 'loading'
 * des: 'Loading 提示'
 * previewUrl: 'components/tiga/ui/loading'
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
  function showLoading1() {
    Taro.showLoading({
      title: '加载中',
      mask: false,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showLoading2() {
    Taro.showLoading({
      title: '加载中',
      mask: true,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showLoading3() {
    Taro.showLoading({
      title: '加载中',
      delay: 5000,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showLoading4() {
    Taro.showLoading({
      title: '加载中',
      delay: 3000,
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function hideLoading() {
    Taro.hideLoading({ context })
  }

  function showAutoHideLoading() {
    Taro.showLoading({
      title: 'loading 自动消失',
      mask: true,
      context,
    })
      .then((res) => {
        setTimeout(() => {
          Taro.hideLoading({ context })
          console.log(res)
        }, 5000)
      })
      .catch((e) => {
        console.log('error' + e)
        Taro.hideLoading({ context })
      })
  }

  return (
    <Layout title='UI' qrcode='components/tiga/ui/loading/index'>
      <DemoBlock label='基础使用' pure>
        <List>
          <ListItem title='加载中提示(无透明蒙层)' arrow='right' onClick={showLoading1} />
          <ListItem title='加载中提示(有透明蒙层)' arrow='right' onClick={showLoading2} />
        </List>
      </DemoBlock>
      <DemoBlock label='延迟展示, 仅app内支持' pure>
        <List>
          <ListItem title='加载中提示(5秒后提示)' arrow='right' onClick={showLoading3} />
          <ListItem title='加载中提示(3秒后提示)' arrow='right' onClick={showLoading4} />
        </List>
      </DemoBlock>
      <DemoBlock label='隐藏loading' pure>
        <List>
          <ListItem title='隐藏loading' arrow='right' onClick={hideLoading} />
        </List>
      </DemoBlock>
      <DemoBlock label='组合使用' pure>
        <List>
          <ListItem title='加载中提示(5秒后自动消失)' arrow='right' onClick={showAutoHideLoading} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
