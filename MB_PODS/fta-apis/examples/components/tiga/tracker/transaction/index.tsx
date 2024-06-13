import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default () => {
  const context = useThreshContext()
  let path = 'pagePath'
  let pageName = 'pageName'
  let count = 0
  let tracker: Tiga.Tracker.TransactionTracker

  function beginTrack(){
    tracker = Tiga.Tracker.beginTransactionTrack(
      {
        metricName: 'performance.pageview',
        path: 'ymm://test/test',
      },
      {
        context: context,
        extraDict: {
          ext1: 'value1',
          ext2: 'value2',
        },
        success: (res) => {
          console.log('beginTransaction-success', res)
        },
        fail: (res) => {
          console.log('beginTransaction-fail', res)
        },
      }
    )
  }

  function addSection(){
    tracker.section(
      {
        sectionName: `section${count++}`,
        path: 'ymm://test/test',
      },
      {
        context: context,
        extraDict: {
          ext1: 'value1',
          ext2: 'value2',
        },
        success: (res) => {
          console.log('addSection-success', res)
        },
        fail: (res) => {
          console.log('addSection-fail', res)
        },
      }
    )
  }

  function beginIsolatedSection(){
    tracker.beginIsolatedSection(
      {
        sectionName: 'isolated_section',
        path: 'ymm://test/test',
      },
      {
        context: context,
        extraDict: {
          ext1: 'value1',
          ext2: 'value2',
        },
        success: (res) => {
          console.log('beginIsolatedSection-success', res)
        },
        fail: (res) => {
          console.log('beginIsolatedSection-fail', res)
        },
      }
    )
  }

  function endIsolatedSection(){
    tracker.endIsolatedSection(
      {
        sectionName: 'isolated_section',
        path: 'ymm://test/test',
      },
      {
        context: context,
        extraDict: {
          ext1: 'value1',
          ext2: 'value2',
        },
        success: (res) => {
          console.log('endIsolatedSection-success', res)
        },
        fail: (res) => {
          console.log('endIsolatedSection-fail', res)
        },
      }
    )
  }

  function endTrack(){
    tracker.end(
      {
        sectionName: 'end section',
        path: 'ymm://test/test',
      },
      {
        context: context,
        extraDict: {
          ext1: 'value1',
          ext2: 'value2',
        },
        success: (res) => {
          console.log('end-success', res)
        },
        fail: (res) => {
          console.log('end-fail', res)
        },
      }
    )
  }


  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/transaction/index'>
      <DemoBlock label='模拟触发自定义分段耗时统计' pure>
        <List>
          <ListItem
            title='开始耗时统计'
            arrow='right'
            onClick={beginTrack}
          />
          <ListItem
            title='添加分段'
            onClick={addSection}
          />
          <ListItem
            title='添加自定义独立分段开始'
            arrow='right'
            onClick={beginIsolatedSection}
          />
          <ListItem
            title='添加自定义独立分段结束'
            arrow='right'
            onClick={endIsolatedSection}
          />
          <ListItem
            title='结束耗时统计'
            arrow='right'
            onClick={endTrack}
          />
        </List>
      </DemoBlock>
    </Layout>
  )
}
