/**
 * title: 'Navigator 路由导航'
 * componentName: 'Navigator'
 * des: '路由导航'
 * previewUrl: 'components/tiga/navigator'
 * materialType: 'component'
 * package: '@fta/components-navigator'
 */
import Tiga from '@fta/tiga'
import { ScrollView } from '@tarojs/components'
import React from 'react'
import { TaroApiView } from './taroPanel'
import { TigaApiView } from './tigaPanel'

export default () => {
  return (
    <ScrollView>
      <TaroApiView />
      <TigaApiView />
    </ScrollView>
  )
}
