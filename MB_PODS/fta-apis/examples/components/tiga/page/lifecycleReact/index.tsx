/**
 * title: 'Page 页面'
 * componentName: 'Page'
 * des: '页面'
 * previewUrl: 'components/tiga/page'
 * materialType: 'component'
 * package: '@fta/components-page'
 */
import { Button } from '@fta/components/common/display'
import { Text, View } from '@tarojs/components'
import React, { Component } from 'react'
import { useThreshContext } from '@fta/hooks'

class Index extends Component {
  componentDidMount() {
    console.log('componentDidMount')
  }

  componentDidShow(options: any) {
    console.log('componentDidShow ' + options)
  }

  componentDidHide() {
    console.log('componentDidHide')
  }

  componentWillUnmount(): void {
    console.log('componentWillUnmount')
  }

  render() {
    return <View className='index' />
  }
}

export default Index
