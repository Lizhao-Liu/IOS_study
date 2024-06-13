import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

function PagePerformanceDemoBlock() {
  const context = useThreshContext()
  let path = 'pagePath'
  let pageName = 'pageName'
  let pageTracker = new Tiga.Tracker.PageViewPerformanceTracker({
    path,
    context,
    extraDict: { common_page_key: 'common_page_value' },
    pageName,
  })
  let pageTrackerManual = new Tiga.Tracker.PageViewPerformanceCustomTracker({
    path,
    context,
    pageName,
  })

  let pageInitiatedTime = Date.now()

  let lastSectionTime: number
  return (
    <>
      <DemoBlock label='页面耗时埋点' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面耗时监控 begin 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面 page_load 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面自定义 section 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面 page_first_layout 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面 page_second_layout 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          模拟触发页面 end 埋点
        </Button>
      </DemoBlock>
      <DemoBlock label='页面耗时埋点(自定义开始结束时间戳)' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            let option: Tiga.Tracker.PageViewPerformanceTrackOption = {
              extraDict: { begin_key: 'begin_value' },
              tags: {
                begin_tag: 0,
              },
            }
            pageTrackerManual
              .begin(option)
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          模拟触发页面耗时监控 begin 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            let currentTime = Date.now()
            let option: Tiga.Tracker.PageViewPerformancePageLoadTrackOptionWithTimestamp = {
              extraDict: { page_load_key: 'page_load_value' },
              tags: {
                page_load_tag: 'page_load_tag_value',
              },
              beginAt: Date.now() - 10,
              endAt: Date.now(),
            }
            pageTrackerManual
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
          }}>
          模拟触发页面 page_load 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            let currentTime = Date.now()
            let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
              extraDict: { first_layout_key: 'first_layout_value' },
              tags: {
                first_layout_tag: true,
              },
              beginAt: Date.now() - 20,
              endAt: Date.now(),
            }
            pageTrackerManual
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
          }}>
          模拟触发页面 page_first_layout 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            let currentTime = Date.now()
            let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
              extraDict: { second_layout_key: 'second_layout_value' },
              tags: {
                second_layout_tag: false,
              },
              beginAt: Date.now() - 30,
              endAt: Date.now(),
            }
            pageTrackerManual
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
          }}>
          模拟触发页面 page_second_layout 埋点
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            let option: Tiga.Tracker.PageViewPerformanceTrackOptionWithTimestamp = {
              beginAt: Date.now() - 40,
              endAt: Date.now(),
            }

            pageTrackerManual
              .end(option)
              .then(() => {
                Taro.showToast({ title: '成功', context })
              })
              .catch((res: any) => {
                Taro.showToast({ title: res.reason, context })
              })
          }}>
          模拟触发页面 end 埋点
        </Button>
      </DemoBlock>
    </>
  )
}

export default PagePerformanceDemoBlock
