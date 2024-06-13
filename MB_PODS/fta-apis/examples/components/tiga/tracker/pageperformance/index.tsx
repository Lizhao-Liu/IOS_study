import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  let path = 'pagePath'
  let pageName = 'pageName'
  let pageTracker = new Tiga.Tracker.PageViewPerformanceTracker({
    path,
    context,
    extraDict: { common_page_key: 'common_page_value' },
    pageName,
  })

  function begin() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { begin_key: 'begin_value' },
      tags: {
        begin_tag: 0,
      },
    }
    pageTracker
      .begin(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function pageLoad() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { page_load_key: 'page_load_value' },
      tags: {
        page_load_tag: 'page_load_tag_value',
      },
    }
    pageTracker
      .pageLoad(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function pageFirstLayout() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { first_layout_key: 'first_layout_value' },
      tags: {
        first_layout_tag: true,
      },
    }
    pageTracker
      .pageFirstLayout(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function pageSecondLayout() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { second_layout_key: 'second_layout_value' },
      tags: {
        second_layout_tag: false,
      },
    }
    pageTracker
      .pageSecondLayout(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function end() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { tti_key: 'tti_value' },
      tags: {
        tti_tag: 'tti_tag_value',
      },
    }
    pageTracker
      .end(option, 'customEndSection')
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function section() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
      extraDict: { custom_section_key: 'custom_section_value' },
      tags: {
        custom_section_tag: 2000,
      },
      beginAt: Date.now() - 1000,
      endAt: Date.now(),
    }
    pageTracker
      .pageCustomIsolatedSection(option, 'page_custom_section')
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }


  let pageTrackerWithTimestamps = new Tiga.Tracker.PageViewPerformanceCustomTracker({
    path,
    context,
    pageName,
  })

  let lastSectionTime: number

  function beginWithTimestamps() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
      extraDict: { begin_key: 'begin_value' },
      tags: {
        begin_tag: 0,
      },
    }
    pageTrackerWithTimestamps
      .begin(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function pageLoadWithTimestamps() {
    let currentTime = Date.now()
    let option: Tiga.Tracker.PageViewPerformancePageLoadTrackOptionWithTimestamp = {
      extraDict: { page_load_key: 'page_load_value' },
      tags: {
        page_load_tag: 'page_load_tag_value',
      },
      beginAt: Date.now() - 10,
      endAt: Date.now(),
    }
    pageTrackerWithTimestamps
      .pageLoad(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
      .finally(() => {
        lastSectionTime = currentTime
      })
  }

  function pageFirstLayoutWithTimestamps() {
    let currentTime = Date.now()
    let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
      extraDict: { first_layout_key: 'first_layout_value' },
      tags: {
        first_layout_tag: true,
      },
      beginAt: Date.now() - 20,
      endAt: Date.now(),
    }
    pageTrackerWithTimestamps
      .pageFirstLayout(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
      .finally(() => {
        lastSectionTime = currentTime
      })
  }

  function pageSecondLayoutWithTimestamps() {
    let currentTime = Date.now()
    let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
      extraDict: { second_layout_key: 'second_layout_value' },
      tags: {
        second_layout_tag: false,
      },
      beginAt: Date.now() - 30,
      endAt: Date.now(),
    }
    pageTrackerWithTimestamps
      .pageSecondLayout(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
      .finally(() => {
        lastSectionTime = currentTime
      })
  }

  function endWithTimestamps() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
      beginAt: Date.now() - 40,
      endAt: Date.now(),
    }

    pageTrackerWithTimestamps
      .end(option)
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function sectionWithTimestamps() {
    let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
      extraDict: { custom_section_key: 'custom_section_value' },
      tags: {
        custom_section_tag: 2000,
      },
      beginAt: Date.now() - 1000,
      endAt: Date.now(),
    }
    pageTrackerWithTimestamps
      .pageCustomIsolatedSection(option, 'page_custom_section')
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/pageperformance/index'>
      <DemoBlock label='自动分段计时' pure>
        <List>
          <ListItem
            title='模拟触发页面耗时监控 begin 埋点'
            arrow='right'
            onClick={begin}
          />
          <ListItem
            title='模拟触发页面 page_load 埋点'
            arrow='right'
            onClick={pageLoad}
          />
          <ListItem
            title='模拟触发页面 page_first_layout 埋点'
            arrow='right'
            onClick={pageFirstLayout}
          />
          <ListItem
            title='模拟触发页面 page_second_layout 埋点'
            arrow='right'
            onClick={pageSecondLayout}
          />
          <ListItem
            title='模拟触发页面 end 埋点'
            arrow='right'
            onClick={end}
          />
          <ListItem
            title='模拟触发页面自定义 section 埋点'
            arrow='right'
            onClick={section}
          />
        </List>
      </DemoBlock>
      <DemoBlock label='手动分段计时(自定义开始结束时间戳)' pure>
        <List>
          <ListItem
            title='模拟触发页面耗时监控 begin 埋点'
            arrow='right'
            onClick={beginWithTimestamps}
          />
          <ListItem
            title='模拟触发页面 page_load 埋点'
            arrow='right'
            onClick={pageLoadWithTimestamps}
          />
          <ListItem
            title='模拟触发页面 page_first_layout 埋点'
            arrow='right'
            onClick={pageFirstLayoutWithTimestamps}
          />
          <ListItem
            title='模拟触发页面 page_second_layout 埋点'
            arrow='right'
            onClick={pageSecondLayoutWithTimestamps}
          />
          <ListItem
            title='模拟触发页面 end 埋点'
            arrow='right'
            onClick={endWithTimestamps}
          />
          <ListItem
            title='模拟触发页面自定义 section 埋点'
            arrow='right'
            onClick={sectionWithTimestamps}
          />
        </List>
      </DemoBlock>
    </Layout>
  )
}
