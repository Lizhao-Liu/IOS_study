import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()

  function getStorageUsage() {
    Tiga.APM.getStorageUsage({ context })
    .then((res: any) => {
      Taro.showModal({
        context,
        content: JSON.stringify(res, null, 2).replace('{', '').replace('}', ''),
        title: '存储空间使用信息',
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

  return (
    <Layout title='apm' qrcode='components/tiga/apm/storage/index'>
      <DemoBlock label='存储空间使用情况' pure>
        <List>
          <ListItem title='获取存储空间使用情况' arrow='right' onClick={getStorageUsage} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
