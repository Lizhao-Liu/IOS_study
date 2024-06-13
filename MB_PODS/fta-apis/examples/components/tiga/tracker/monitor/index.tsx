import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

export default () => {
  const context = useThreshContext()
  function metricMonitor() {
    Tiga.Tracker.metricMonitor({
      name: 'your_metric_name',
      /* other parameters */
    })
      .attrs({ key: 'value' })
      .stack({
        stack: 'stack_string',
        mappingType: 'mapping_type',
        stackType: 'stack_type',
      })
      .reportSuccessRate(true)
      .extra({ metric_extra_key: 'metric_extra_value' })
      .track({
        context,
        success: (res: any) => {
          Taro.showToast({ title: '成功', context })
        },
        fail: (res: any) => {
          console.log(res)
        },
        complete: (res: any) => {
          console.log(res)
        },
      })
  }

  function performanceMonitor() {
    Tiga.Tracker.performanceMonitor({
      name: 'your_performance_metric_name',
      value: 123,
      /* other parameters */
    })
      .extra({ performance_extra_key: 'performance_extra_value' })
      .attrs({ key: 'value' })
      .reportApmResourceInfo({
        memory: { duration: 100 },
        cpu: { duration: 100 },
        storage: true,
      })
      .track({ context })
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function errorMonitor() {
    Tiga.Tracker.errorMonitor({
      errorTag: 'your_error_tag',
      errorFeature: 'your_error_feature',
      /* other parameters */
    })
      .extra({ error_extra_key: 'error_extra_value' })
      .stack({
        context,
        stack: 'stack_string',
        mappingType: 'mapping_type',
        stackType: 'stack_type',
      })
      .track({
        context,
      })
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function networkMonitor() {
    Tiga.Tracker.networkMonitor({
      url: 'your_url',
      code: 200,
      success: true,
      responseTime: 99,
      /* other parameters */
    })
      .extra({ network_extra_key: 'network_extra_value' })
      .track({
        context,
        /* optional callback blocks */
      })
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  function cosmosMonitor() {
    Tiga.Tracker.cosmosMonitor({
      model: 'your_model',
      scenario: 'your_scenario',
      event: Tiga.Tracker.CosmosEventLevel.Error,
    })
      .extra({ cosmos_extra_key: 'cosmos_extra_value' })
      .priority(Tiga.Tracker.MonitorEventReportPriority.High)
      .track({
        context,
        success: (res) => {
          Taro.showToast({ title: '成功', context })
        },
        fail: (res) => {
          Taro.showToast({ title: res.reason, context })
        },
        complete: (res) => {
          /* handle completion, either success or fail */
        },
      })
  }

  function hubbleAndCosmosMonitor() {
   Tiga.Tracker.hubbleAndCosmosMonitor({
      hubble: {
        metric: { name: 'metric_name', value: 123 },
        attrs: { testKey: 'testValue' },
      },
      cosmos: {
        model: 'your_model',
        scenario: 'your_scenario',
        event: Tiga.Tracker.CosmosEventLevel.Warning,
      },
    })
      .priority(Tiga.Tracker.MonitorEventReportPriority.Normal)
      .extra({ hubble_cosmos_extra_key: 'hubble_cosmos_extra_value' })
      .track({
        context,
        /* optional callback blocks */
      })
      .then(() => {
        Taro.showToast({ title: '成功', context })
      })
      .catch((res: any) => {
        Taro.showToast({ title: res.reason, context })
      })
  }

  return (
    <Layout title='tracker' qrcode='components/tiga/tracker/monitor/index'>
      <DemoBlock label='上报监控数据至 Hubble' pure>
        <List>
          <ListItem
            title='自定义指标'
            arrow='right'
            onClick={metricMonitor}
          />
          <ListItem
            title='Performance 指标'
            arrow='right'
            onClick={performanceMonitor}
          />
          <ListItem
            title='Error 指标'
            arrow='right'
            onClick={errorMonitor}
          />
        </List>
      </DemoBlock>
      <DemoBlock label='上报监控数据至 Cosmos 大数据平台' pure>
        <List>
        <ListItem
            title='Error 事件'
            arrow='right'
            onClick={cosmosMonitor}
          />
        </List>
      </DemoBlock>
      <DemoBlock label='上报监控数据至 Hubble 和 Cosmos 大数据平台' pure>
        <List>
          <ListItem
            title={`同时上报自定义指标 & Warning 事件`}
            arrow='right'
            onClick={hubbleAndCosmosMonitor}
          />
        </List>
      </DemoBlock>
      <DemoBlock label='网络数据上报' pure>
        <List>
        <ListItem
            title='Network 数据'
            arrow='right'
            onClick={networkMonitor}
          />
        </List>
      </DemoBlock>
    </Layout>
  )
}
