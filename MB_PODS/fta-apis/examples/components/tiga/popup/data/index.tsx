/**
 * title: '添加数据'
 * componentName: 'Popup'
 * des: '弹窗管控'
 * previewUrl: 'components/tiga/popup'
 * materialType: 'component'
 * package: '@fta/components-popup'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='popup' qrcode='components/${type}/${name}/index'>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=insert`,
              context,
            })
          }}>
          添加自定义弹窗数据
        </Button>
      </DemoBlock>
    </Layout>
  )
}
