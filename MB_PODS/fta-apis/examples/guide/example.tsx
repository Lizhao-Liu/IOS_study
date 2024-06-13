import React from 'react'
import { View, Text } from '@tarojs/components'
import Layout from '@components/layout'

const attributes = {
  col: {
    label: '属性',
    options: ['small', 'middle', 'big'],
  },
}

export default () => {
  return (
    <Layout title='组件演示' attributes={attributes}>
      <Text>我是一个组件演示示例</Text>
    </Layout>
  )
}
