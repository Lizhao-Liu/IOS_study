import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default () => {
  const context = useThreshContext()

  return (
    <Layout title='Navigator' qrcode='components/tiga/navigator/getapppages/index'>
      <DemoBlock label='查询当前页面历史栈' pure>
        <Button
          onClick={() => {
            Tiga.Navigator.getAppPages({ context })
            .then((res) => console.log('getAppPages', res.pages))
            .catch((err) => console.error('getAppPages', err))
          }}>
          查询当前页面历史栈
        </Button>
      </DemoBlock>
    </Layout>
  )
}
