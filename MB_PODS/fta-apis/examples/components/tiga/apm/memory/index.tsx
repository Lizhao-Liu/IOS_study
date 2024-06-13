import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  const listener = function (res: any) {
    Taro.showModal({
      context,
      content: 'onMemoryWarningReceive',
      title: '监听到内存告警',
      showCancel: false,
    })
  }

  function getMemoryUsage() {
    Tiga.APM.getMemoryUsage({ context })
    .then((res: any) => {
      Taro.showModal({
        context,
        content: JSON.stringify(res, null, 2).replace('{', '').replace('}', ''),
        title: '内存使用信息',
        showCancel: false,
      })
    })
    .catch((e: any) => {
      Taro.showModal({
        context,
        content: e.reason ? e.reason : '',
        title: '失败',
        showCancel: false,
      })
    })
  }

  function onMemoryWarning() {
    Taro.onMemoryWarning(listener)
  }

  function offMemoryWarning() {
    Taro.offMemoryWarning(listener)
  }

  return (
    <Layout title='apm' qrcode='components/tiga/apm/memory/index'>
      <DemoBlock label='内存使用情况' pure>
        <List>
          <ListItem title='获取内存使用情况' arrow='right' onClick={getMemoryUsage} />
        </List>
      </DemoBlock>

      <DemoBlock label='系统内存不足告警事件' pure>
        <List>
          <ListItem title='监听系统内存不足告警事件' arrow='right' onClick={onMemoryWarning} />
          <ListItem title='取消监听内存不足告警事件' arrow='right' onClick={offMemoryWarning} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
