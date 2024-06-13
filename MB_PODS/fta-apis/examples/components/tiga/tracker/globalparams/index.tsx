import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  function setGlobalExtraParams() {
    Tiga.Tracker.setGlobalExtraParams(() => {
      return {
        global_bundle_key: 'global_bundle_value',
      }
    })
  }

  function clearGlobalExtraParams() {
    Tiga.Tracker.clearGlobalExtraParams()
  }

  function getGlobalExtraParams() {
    Taro.showModal({
      context,
      title: '埋点全局参数',
      content: JSON.stringify(Tiga.Tracker.getGlobalExtraParams()),
    })
  }

  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/globalparams/index'>
      <DemoBlock label='全局业务自定义参数' pure>
        <List>
          <ListItem
            title='设置埋点全局业务自定义参数'
            arrow='right'
            onClick={setGlobalExtraParams}
          />
          <ListItem
            title='获取埋点全局业务自定义参数'
            arrow='right'
            onClick={getGlobalExtraParams}
          />
          <ListItem
            title='清空埋点全局业务自定义参数'
            arrow='right'
            onClick={clearGlobalExtraParams}
          />
        </List>
      </DemoBlock>
    </Layout>
  )
}
