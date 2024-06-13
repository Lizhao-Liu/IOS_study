import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()
  function launchWXMiniProgram() {
    Tiga.Social.launchWXMiniProgram({
      userName: 'gh_54e9dea35b85',
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: e.reason,
        title: '小程序跳转失败',
        showCancel: false,
      })
    })
  }
  function launchAlipayMiniProgram() {
    Tiga.Social.launchAlipayMiniProgram({
      appId: '60000002',
      context,
    }).catch((e: any) => {
      Taro.showModal({
        context,
        content: e.reason,
        title: '小程序跳转失败',
        showCancel: false,
      })
    })
  }

  return (
    <Layout title='social' qrcode='components/tiga/social/miniprogram/index'>
      <DemoBlock label='打开小程序' pure>
        <List>
          <ListItem title='打开微信小程序' arrow='right' onClick={launchWXMiniProgram} />
          <ListItem title='打开支付宝小程序' arrow='right' onClick={launchAlipayMiniProgram} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
