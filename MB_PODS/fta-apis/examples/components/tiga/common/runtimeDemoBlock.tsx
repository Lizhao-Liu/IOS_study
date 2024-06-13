import { InputNumber, Toggle } from '@fta/components'
import { Button, DemoBlock, Row } from '@fta/components/common/display'
import { Text } from '@tarojs/components'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import Tiga, { TigaGeneral } from '@fta/tiga'
import React, { useEffect, useState } from 'react'

function RuntimeDemoBlock() {
  const context = useThreshContext()

  const [runtimeResult, setRuntimeResult] = useState('')

  return (
    <>
      <DemoBlock label='App Runtime API' pure>
        {runtimeResult ? <Text style={{ padding: 8 }}>{runtimeResult ?? ''}</Text> : false}
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() => {
              Tiga.Common.getBundleInfo({
                context: context,
                bundles: [
                  {
                    bundleType: 'plugin',
                  },
                  {
                    bundleType: 'flutter',
                  },
                  {
                    bundleType: 'rn',
                    bundleNames: ['fta-user', 'global-engine', 'common'],
                  },
                ],
                success: (res) => {
                  console.log('getBundleInfo-success', res)
                  setRuntimeResult(`getBundleInfo success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getBundleInfo-fail', res)
                  setRuntimeResult(`getBundleInfo failed, result: ${JSON.stringify(res)}`)
                },
              })
            }}>
            getBundleInfo
          </Button>
          <Button
            onClick={() =>
              Tiga.Common.getPluginInfo({
                context: context,
                pluginName: 'com.wlqq.phantom.plugin.ymm.cargo',
                success: (res) => {
                  console.log('getPluginInfo-success', res)
                  setRuntimeResult(`getPluginInfo success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getPluginInfo-fail', res)
                  setRuntimeResult(`getPluginInfo failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            Android getPluginInfo
          </Button>
        </Row>
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() => {
              Tiga.Common.getProcessInfo({
                context: context,
                success: (res) => {
                  console.log('getProcessInfo-success', res)
                  setRuntimeResult(`getProcessInfo success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getProcessInfo-fail', res)
                  setRuntimeResult(`getProcessInfo failed, result: ${JSON.stringify(res)}`)
                },
              })
            }}>
            getProcessInfo
          </Button>
          <Button
            onClick={() =>
              Tiga.Common.getSessionInfo({
                context: context,
                success: (res) => {
                  console.log('getSessionInfo-success', res)
                  setRuntimeResult(`getSessionInfo success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getSessionInfo-fail', res)
                  setRuntimeResult(`getSessionInfo failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            getSessionInfo
          </Button>
        </Row>
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() =>
              Tiga.Common.getAppLaunchTime({
                context: context,
                success(res) {
                  console.log('getAppLaunchTime-success', res)
                  setRuntimeResult(`getAppLaunchTime success, result: ${JSON.stringify(res)}`)
                },
                complete(res) {},
                fail(res) {
                  console.log('getAppLaunchTime-fail', res)
                  setRuntimeResult(`getAppLaunchTime failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            getAppLaunchTime
          </Button>
          <Button
            onClick={() =>
              Tiga.Common.getCurrentTime({
                context: context,
                success: (res) => {
                  console.log('getCurrentTime-success', res)
                  setRuntimeResult(`getCurrentTime success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getCurrentTime-fail', res)
                  setRuntimeResult(`getCurrentTime failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            getCurrentTime
          </Button>
        </Row>
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() =>
              Tiga.Common.isAppForeground({
                context: context,
                success(res) {
                  console.log('isAppForeground-success', res)
                  setRuntimeResult(`isAppForeground success, result: ${JSON.stringify(res)}`)
                },
                complete(res) {},
                fail(res) {
                  console.log('isAppForeground-fail', res)
                  setRuntimeResult(`isAppForeground failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            isAppForeground
          </Button>
          <Button
            onClick={() =>
              Tiga.Common.isAppOpenedViaScheme({
                context: context,
                success(res) {
                  console.log('isAppOpenedViaScheme-success', res)
                  setRuntimeResult(`isAppOpenedViaScheme success, result: ${JSON.stringify(res)}`)
                },
                complete(res) {},
                fail(res) {
                  console.log('isAppOpenedViaScheme-fail', res)
                  setRuntimeResult(`isAppOpenedViaScheme failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            isAppOpenedViaScheme
          </Button>
        </Row>
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() =>
              Tiga.Common.getNetworkInfo({
                context: context,
                success: (res) => {
                  console.log('getNetworkInfo-success', res)
                  setRuntimeResult(`getNetworkInfo success, result: ${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getNetworkInfo-fail', res)
                  setRuntimeResult(`getNetworkInfo failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            getNetworkInfo
          </Button>
          <Button
            onClick={() =>
              Tiga.Common.getTigaSDKVersion({
                context: context,
                success(res) {
                  console.log('getSDKVersion-success', res)
                  setRuntimeResult(`getSDKVersion success, result: ${JSON.stringify(res)}`)
                },
                fail(res) {
                  console.log('getSDKVersion-fail', res)
                  setRuntimeResult(`getSDKVersion failed, result: ${JSON.stringify(res)}`)
                },
              })
            }>
            getTigaSDKVersion
          </Button>
        </Row>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            const bundle: TigaGeneral.BundleInfo = TigaGeneral.getBundleInfo()
            console.log('TigaGeneral.getBundleInfo ', bundle)
            setRuntimeResult(`TigaGeneral.getBundleInfo, result: ${JSON.stringify(bundle)}`)
          }}>
          当前 BundleInfo
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() =>
            Tiga.Common.exitApp({
              context: context,
              success(res) {
                console.log('exitApp-success', res)
              },
              fail(res) {
                console.log('exitApp-fail', res)
              },
            })
          }>
          exitApp
        </Button>
      </DemoBlock>
    </>
  )
}

export default RuntimeDemoBlock
