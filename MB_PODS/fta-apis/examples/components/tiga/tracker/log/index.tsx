import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  function errorLog() {
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
  }

  function warningLog() {
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
  }

  function debugLog() {
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
  }

  function infoLog() {
    Tiga.Tracker.infoLog({ tag: 'log_tag', message: 'this is a message', context })
    .then(() => {
      Taro.showToast({ title: '成功', context })
    })
    .catch((res: any) => {
      Taro.showToast({ title: res.reason, context })
    })
  }

  function fatalLog() {
    Tiga.Tracker.fatalLog({
      tag: 'log_fatal_tag',
      message: 'this is a fatal message',
      context,
    })
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/log/index'>
      <DemoBlock label='日志上报' pure>
        <List>
          <ListItem
            title='debug日志'
            arrow='right'
            onClick={debugLog}
          />
          <ListItem
            title='error日志'
            arrow='right'
            onClick={errorLog}
          />
          <ListItem
            title='warning日志'
            arrow='right'
            onClick={warningLog}
          />
          <ListItem
            title='info日志'
            arrow='right'
            onClick={infoLog}
          />
          <ListItem
            title='fatal日志'
            arrow='right'
            onClick={fatalLog}
          />
        </List>
      </DemoBlock>
    </Layout>
  )
}
