import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'


export default () => {
  const context = useThreshContext()

  function popOnePushOne() {
    Tiga.Navigator.navigate({
      push: { url: 'ymm://app/testpush' },
      pop: { delta: 1 },
      context: context,
    })
  }
  function popTwoPushOne() {
    Tiga.Navigator.navigate({
      push: { url: 'this:///components/tiga/navigator/index' },
      pop: { delta: 2 },
      context: context,
    })
  }
  function replace() {
    Tiga.Navigator.navigate({
      push: { url: 'ymm://app/testpush', anim: Tiga.Navigator.ANIM_NONE },
      pop: { delta: 1 },
      context: context,
      style: Tiga.Navigator.STYLE_PUSH_FIRST
    })
  }
  return (
    <Layout title='Navigator' qrcode='components/tiga/navigator/navigate/index'>
      <DemoBlock label='组合执行页面跳转' pure>
        <List>
          <ListItem title='pop + push' arrow='right' onClick={popOnePushOne} />
          <ListItem title='pop 2 + push' arrow='right' onClick={popTwoPushOne} />
          <ListItem title='replace' arrow='right' onClick={replace} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
