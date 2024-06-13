import { DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import { Button } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React from 'react'

export function TaroApiView() {
  const context = useThreshContext()
  return (
    <DemoBlock label='Taro' flexDirection='column'>
      <Button
        onClick={() => {
          Taro.navigateTo({ url: '/components/tiga/navigator/index', context }).catch((err) =>
            console.error(err)
          )
        }}>
        navigateTo index
      </Button>
      <Button
        onClick={() => {
          Taro.navigateTo({ url: '/components/tiga/navigator/alice', context }).catch((err) =>
            console.error(err)
          )
        }}>
        navigateTo alice
      </Button>
      <Button
        onClick={() => {
          Taro.navigateBack({ context })
        }}>
        navigateBack
      </Button>
      <Button
        onClick={() => {
          Taro.redirectTo({ url: '/components/overall/overall', context }).catch((err) =>
            console.error(err)
          )
        }}>
        redirectTo overall
      </Button>
    </DemoBlock>
  )
}
