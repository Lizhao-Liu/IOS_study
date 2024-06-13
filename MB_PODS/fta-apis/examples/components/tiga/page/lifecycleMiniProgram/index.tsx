/**
 * title: 'Page 页面'
 * componentName: 'Page'
 * des: '页面'
 * previewUrl: 'components/tiga/page'
 * materialType: 'component'
 * package: '@fta/components-page'
 */
import { Text, View } from '@tarojs/components'
import React, { Component } from 'react'

class Index extends Component {
  onLoad() {
    console.log('onLoad')
  }

  onUnload() {
    console.log('onUnload')
  }

  onReady() {
    console.log('onReady')
  }

  render() {
    return (
      <View className='index'>
        <Text>Page Lifecycle Mini Program</Text>
      </View>
    )
  }
}

export default Index
