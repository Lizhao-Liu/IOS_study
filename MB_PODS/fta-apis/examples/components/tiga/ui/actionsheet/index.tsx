/**
 * componentName: 'actionsheet'
 * des: 'actionsheet 底部操作菜单'
 * previewUrl: 'components/tiga/ui/actionsheet'
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
  function showActionSheet1() {
    Taro.showActionSheet({
      itemList: ['选项一', '选项二', '选项三'],
      alertText: 'alert text',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showActionSheet2() {
    Taro.showActionSheet({
      itemList: ['选项一', '选项二'],
      alertText: 'alert text',
      itemColor: '#008B8B',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  return (
    <Layout title='UI' qrcode='components/tiga/ui/actionsheet/index'>
      <DemoBlock label='底部菜单' pure>
        <List>
          <ListItem title='基础样式' arrow='right' onClick={showActionSheet1} />
          <ListItem title='自定义颜色' arrow='right' onClick={showActionSheet2} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
