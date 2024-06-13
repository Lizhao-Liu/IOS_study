import { DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { Button, View } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React from 'react'
import FileDemoBlock from './fileDemo'

function TaroApiList() {
  const threshContext = useThreshContext()
  return (
    <DemoBlock label={'Taro API'} flexDirection='column'>
      <Button
        onClick={() => {
          Taro.getStorageInfo({
            context: threshContext,
            success(res) {
              console.log('success', res.keys, res.currentSize, res.limitSize)
            },
            fail(res) {
              console.log('fail', res.errMsg)
            },
          })
        }}>
        getStorageInfo
      </Button>

      {/* <Button
        onClick={() => {
          var res = Taro.getStorageInfoSync()
          console.log(res.keys, res.currentSize, res.limitSize)
        }

        }>
        getStorageInfoSync
      </Button> */}

      <Button
        onClick={() => {
          Taro.setStorage({ key: 'foo', data: 'bar', context: threshContext })
        }}>
        setStorage
      </Button>

      <Button
        onClick={() => {
          Taro.getStorage({ key: 'foo', context: threshContext }).then(
            (res) => console.log('value: ' + res.data),
            (res) => console.log('errMsg: ' + res.errMsg)
          )
        }}>
        getStorage
      </Button>

      <Button
        onClick={() => {
          Taro.removeStorage({ key: 'foo', context: threshContext }).then(
            (res) => console.log('Fulfilled. ' + res.errMsg),
            (res) => console.log('Rejected. ' + res.errMsg)
          )
        }}>
        removeStorage
      </Button>

      <Button
        onClick={() => {
          Taro.clearStorage({ context: threshContext }).then(
            (res) => console.log('Fulfilled. ' + res.errMsg),
            (res) => console.log('Rejected. ' + res.errMsg)
          )
        }}>
        clearStorage
      </Button>
    </DemoBlock>
  )
}

function TigaApiList() {
  const threshContext = useThreshContext()
  // const storage = useCallback(
  //   () => {
  //     Tiga.Storage.getKvStorage({
  //       privacy: 'package',
  //       context: threshContext
  //     });
  //   },
  //   [],
  // )
  const storage = Tiga.Storage.getKvStorage({
    privacy: 'package',
    context: threshContext,
  })

  return (
    <DemoBlock label={'Tiga API'} flexDirection='column'>
      <Button
        onClick={() => {
          storage.info().then(
            (res) => console.log(res.keys, res.currentSize, res.limitSize),
            (res) => console.log('rejected: ' + res.reason)
          )
        }}>
        Tiga info
      </Button>

      <Button
        onClick={() => {
          storage.set({ key: 'foo', data: 'bar' }).then(
            (res) => console.log('Fulfulled.'),
            (res) => console.log('Rejected. ' + res.reason)
          )
        }}>
        Tiga set
      </Button>

      <Button
        onClick={() => {
          storage
            .get({
              key: 'foo',
            })
            .then(
              (res) => console.log('value: ' + res.data),
              (res) => console.log('reason: ' + res.reason)
            )
        }}>
        Tiga get
      </Button>

      <Button
        onClick={() => {
          storage
            .remove({
              key: 'foo',
            })
            .then(
              (res) => console.log('removed'),
              (res) => console.log('reason: ' + res.reason)
            )
        }}>
        Tiga remove
      </Button>

      <Button
        onClick={() => {
          storage.clear().then(
            (res) => console.log('cleared'),
            (res) => console.log('reason: ' + res.reason)
          )
        }}>
        Tiga clear
      </Button>
    </DemoBlock>
  )
}

export default () => {
  return (
    <Layout title='存储' style={{ flex: 1 }}>
      <TaroApiList />
      <TigaApiList />

      <FileDemoBlock></FileDemoBlock>
    </Layout>
  )
}
