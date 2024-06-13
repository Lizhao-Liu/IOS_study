import React from 'react'
import { View, Text } from '@tarojs/components'
import Layout from '@components/layout'

const attributes = {
  col: {
    label: '功能',
    options: ['small', 'middle', 'big'],
  },
}

export default () => {
  return (
    <Layout title='模块演示' attributes={attributes}>
      <Text>我是一个模块演示示例</Text>
    </Layout>
  )
}
