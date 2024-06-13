import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'

function MonitorTrackerDemoBlock() {
  const context = useThreshContext()
  return (
    <>
      <DemoBlock label='Monitor Event Report' pure>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Metric Report
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Performance Report (with apm resource usage)
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Error Report
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Network Report
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Cosmos Report
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
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
          }}>
          Mock Hubble And Cosmos Report
        </Button>
      </DemoBlock>
    </>
  )
}

export default MonitorTrackerDemoBlock
