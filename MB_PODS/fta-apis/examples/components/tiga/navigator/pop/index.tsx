import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'


export default () => {
  const context = useThreshContext()

  function popOne() {
    Tiga.Navigator.pop({ delta: 1, context: context })
  }
  function popTwo() {
    Tiga.Navigator.pop({ delta: 2, context: context })
  }
  function popUntil() {
    Tiga.Navigator.popUntil({
      predicate: (url: string) => {
        const res = url.startsWith('this:///components/tiga/navigator/alice')
        console.log('predicate', url, res)
        return res
      },
      context: context,
    })
  }

  function navigateBack() {
    Taro.navigateBack({ context })
  }

  return (
    <Layout title='Navigator' qrcode='components/tiga/navigator/pop/index'>
      <DemoBlock label='使用Tiga方法回退页面' pure>
        <List>
          <ListItem title='回退一个页面' arrow='right' onClick={popOne} />
          <ListItem title='回退两个页面' arrow='right' onClick={popTwo} />
          <ListItem title='回退页面，直到新的栈顶页面符合条件' arrow='right' onClick={popUntil} />
        </List>
      </DemoBlock>
      <DemoBlock label='使用Taro方法回退页面' pure>
        <List>
          <ListItem title='回退到上一级页面' arrow='right' onClick={navigateBack} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
