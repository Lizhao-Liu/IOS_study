import { DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { Button } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React from 'react'

export function TigaApiView() {
  const context = useThreshContext()
  return (
    <DemoBlock label='Tiga' flexDirection='column'>
      <Button
        onClick={() => {
          Tiga.Navigator.push({
            url: 'this:///components/tiga/navigator/index',
            context: context,
          })
        }}>
        push
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.push({
            url: 'this:///components/tiga/navigator/index',
            flag: Tiga.Navigator.FLAG_KEEP_CONTAINER,
            context: context,
            onResult: (resultData) => {
              console.log('onResult', resultData)
              Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
            },
          })
        }}>
        push local
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.push({
            url: 'this:///components/tiga/navigator/index',
            flag: Tiga.Navigator.FLAG_NEW_CONTAINER,
            context: context,
            onResult: (resultData) => {
              console.log('onResult', resultData)
              Taro.showToast({ title: `onResult: ${JSON.stringify(resultData)}` })
            },
          })
            .then((result) => {
              console.log('fulfilled')
            })
            .catch((result) => {
              console.log(result)
            })
        }}>
        push remote
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.push({
            url: 'this:///components/overall/overall',
            flag: Tiga.Navigator.FLAG_CLEAR_TOP,
            context: context,
          })
        }}>
        push clear top
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.pop({ delta: 1, context: context })
        }}>
        pop
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.pop({ delta: 2, context: context })
        }}>
        pop 2
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.popUntil({
            predicate: (url: string) => {
              const res = url.startsWith('this:///components/tiga/navigator/alice')
              console.log('predicate', url, res)
              return res
            },
            context: context,
          })
        }}>
        popUntil
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.navigate({
            push: { url: 'ymm://app/testpush' },
            pop: { delta: 1 },
            context: context,
          })
        }}>
        pop + push
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.navigate({
            push: { url: 'this:///components/tiga/navigator/index' },
            pop: { delta: 2 },
            context: context,
          })
        }}>
        pop 2 + push
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.navigate({
            push: { url: 'ymm://app/testpush' },
            pop: { delta: 1 },
            context: context,
            style: Tiga.Navigator.STYLE_NO_ANIM
          })
        }}>
        replace
      </Button>
      <Button
        onClick={() => {
          Tiga.Navigator.getAppPages({ context })
            .then((res) => console.log('getAppPages', res.pages))
            .catch((err) => console.error('getAppPages', err))
        }}>
        getAppPages
      </Button>
      <Button
        onClick={() => {
          const resultData = { foo: 'bar' }
          Tiga.Navigator.setResult({ context, resultData })
            .then(() => {
              console.log('setResult', resultData)
              Taro.showToast({ title: `setResult: ${JSON.stringify(resultData)}` })
            })
            .catch((err) => {
              console.error('setResult', err)
            })
        }}>
        setResult
      </Button>
    </DemoBlock>
  )
}
