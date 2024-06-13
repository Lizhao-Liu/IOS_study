import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

function LogDemoBlock() {
  const context = useThreshContext()
  return (
    <>
      <DemoBlock label='Log With Level' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Tracker.errorLog({
              tag: 'log_error_tag',
              message: 'this is an error message',
              context,
            })
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          error log
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Tracker.warningLog({
              tag: 'log_warning_tag',
              message: 'this is a warning message',
              context,
            })
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          warning log
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Tracker.debugLog({
              tag: 'log_debug_tag',
              message: 'this is a debug message',
              context,
            })
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          debug log
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Tracker.infoLog({ tag: 'log_tag', message: 'this is a message', context })
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          info log
        </Button>
      </DemoBlock>
    </>
  )
}

export default LogDemoBlock
