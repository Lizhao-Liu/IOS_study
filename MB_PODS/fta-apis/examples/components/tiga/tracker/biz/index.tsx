import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default () => {
  const context = useThreshContext()
  function pageView() {
    Tiga.Tracker.pageview({
      context,
      pageName: 'test',
      pageSessionId: 'psi1234',
      referSpm: 'login',
      success: (res) => {
        console.log('pageviewTrack-success', res)
      },
      fail: (res) => {
        console.log('pageviewTrack-fail', res)
      },
    })
  }

  function pageviewDuration() {
    Tiga.Tracker.pageviewDuration({
      context,
      pageName: 'test',
      pageSessionId: 'psi1234',
      duration: 16000,
      referSpm: 'login',
      success: (res) => {
        console.log('pageviewDurationTrack-success', res)
      },
      fail: (res) => {
        console.log('pageviewDurationTrack-fail', res)
      },
    })
  }

  function tap() {
    Tiga.Tracker.tap({
      context,
      pageName: 'test',
      elementId: 'button',
      region: 'top',
      pageSessionId: 'psi1234',
      referSpm: 'login',
      success: (res) => {
        console.log('tapTrack-success', res)
      },
      fail: (res) => {
        console.log('tapTrack-fail', res)
      },
    })
  }

  function exposure() {
    Tiga.Tracker.exposure({
      context,
      pageName: 'test',
      elementId: 'button',
      region: 'top',
      pageSessionId: 'psi1234',
      elementUniqueKey: 'uniqueKey123',
      referSpm: 'login',
      success: (res) => {
        console.log('exposureTrack-success', res)
      },
      fail: (res) => {
        console.log('exposureTrack-fail', res)
      },
    })
  }

  function clearCache() {
    Tiga.Tracker.clearCache({
      context,
      type: 'exposure',
      exposureFactors: {
        pageName: 'test',
        elementId: 'button',
        region: 'top',
        pageSessionId: 'psi1234',
      },
      success: (res) => {
        console.log('clearTrackCache-success', res)
      },
      fail: (res) => {
        console.log('clearTrackCache-fail', res)
      },
    })
  }

  function regionExposure() {
    Tiga.Tracker.regionExposure({
      context,
      pageName: 'test',
      pageSessionId: 'psi1234',
      referSpm: 'login',
      region: 'top',
    })
  }

  function regionDuration() {
    Tiga.Tracker.regionDuration({
      context,
      pageName: 'test',
      pageSessionId: 'psi1234',
      duration: 16000,
      region: 'top',
      referSpm: 'login',
      success: (res) => {
        console.log('pageviewDurationTrack-success', res)
      },
      fail: (res) => {
        console.log('pageviewDurationTrack-fail', res)
      },
    })
  }

  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/biz/index'>
      <DemoBlock label='业务通用埋点' pure>
        <List>
          <ListItem title='页面曝光埋点' arrow='right' onClick={pageView} />
          <ListItem title='页面停留时长埋点' arrow='right' onClick={pageviewDuration} />
          <ListItem title='控件曝光埋点' arrow='right' onClick={exposure} />
          <ListItem title='控件点击埋点' arrow='right' onClick={tap} />
          <ListItem title='区块曝光埋点' arrow='right' onClick={regionExposure} />
          <ListItem title='区块停留时长埋点' arrow='right' onClick={regionDuration} />
          <ListItem title='清除埋点缓存' arrow='right' onClick={clearCache} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
