/**
 * title: '屏幕'
 * componentName: 'System'
 * des: '系统设置'
 * previewUrl: 'components/tiga/system'
 * materialType: 'component'
 * package: '@fta/components-system'
 */
import { Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import React from 'react'
import ScreenDemoBlock from '../screenDemo'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='screen' qrcode='components/tiga/system/screen' style={{ flex: 1 }}>
      <ScreenDemoBlock></ScreenDemoBlock>
    </Layout>
  )
}
