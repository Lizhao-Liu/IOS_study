/**
 * title: 'Tracker 埋点'
 * componentName: 'Tracker'
 * des: '埋点'
 * previewUrl: 'components/tiga/tracker'
 * materialType: 'component'
 * package: '@fta/tiga-tracker'
 */
import { Button, Layout, Row } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'
import LogDemoBlock from './LogDemo'
import MonitorTrackerDemoBlock from './MonitorTrackerDemo'
import PagePerformanceDemoBlock from './PagePerformanceDemo'

export default () => {
  const context = useThreshContext()
  let tracker: Tiga.Tracker.TransactionTracker
  let count = 0
  Tiga.Tracker.setGlobalExtraParams(() => {
    return {
      global_bundle_key: 'global_bundle_value',
    }
  })

  return (
    <Layout title='Tiga SDK' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.pageview({
            context: context,
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
        }}>
        pageview
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.pageviewDuration({
            context: context,
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
        }}>
        pvDuration
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.tap({
            context: context,
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
        }}>
        tap
      </Button>
      <Row>
        <Button
          style={{ marginLeft: 8, marginTop: 8, marginBottom: 8, marginRight: 4 }}
          onClick={() => {
            Tiga.Tracker.exposure({
              context: context,
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
          }}>
          exposure
        </Button>
        <Button
          style={{ marginLeft: 4, marginTop: 8, marginBottom: 8, marginRight: 8 }}
          onClick={() => {
            Tiga.Tracker.clearCache({
              context: context,
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
          }}>
          clearExposureCache
        </Button>
      </Row>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.regionExposure({
            context: context,
            pageName: 'test',
            pageSessionId: 'psi1234',
            referSpm: 'login',
            region: 'top',
            success: (res) => {
              console.log('pageviewDurationTrack-success', res)
            },
            fail: (res) => {
              console.log('pageviewDurationTrack-fail', res)
            },
          })
        }}>
        region Exposure
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.regionDuration({
            context: context,
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
        }}>
        region Duration
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.monitor({
            context: context,
            metric: {
              name: 'phantom_core',
              type: Tiga.Tracker.MetricType.Counter,
              value: 1,
            },
            category: 'custom',
            attrs: {
              attr1: 'value1',
              attr2: 'value2',
            },
            extraDict: {
              ext1: 'value1',
              ext2: 'value2',
            },
            model: 'test',
            scenario: 'test',
            event: Tiga.Tracker.EventLevel.Warning,
            success: (res) => {
              console.log('monitorTrack-success', res)
            },
            fail: (res) => {
              console.log('monitorTrack-fail', res)
            },
          })
        }}>
        monitor
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.error({
            context: context,
            errorTag: 'test',
            errorFeature: 'test_feature',
            errorDetail: 'error detail',
            metricTags: {
              tag1: 'value1',
              tag2: 'value2',
            },
            extraDict: {
              ext1: 'value1',
              ext2: 'value2',
            },
            success: (res) => {
              console.log('errorTrack-success', res)
            },
            fail: (res) => {
              console.log('errorTrack-fail', res)
            },
          })
        }}>
        error
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.network({
            context: context,
            url: 'https://www.ymm56.com/testapi',
            isSuccess: true,
            code: 200,
            responseTime: 120,
            bCode: 1,
            traceId: 'hango-122353',
            requestId: 'ri-123456',
            extraDict: {
              ext1: 'value1',
              ext2: 'value2',
            },
            success: (res) => {
              console.log('networkTrack-success', res)
            },
            fail: (res) => {
              console.log('networkTrack-fail', res)
            },
          })
        }}>
        network
      </Button>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
          Tiga.Tracker.log({
            context: context,
            level: Tiga.Tracker.LogLevel.Warning,
            tag: 'test',
            message: 'log message log message',
            success: (res) => {
              console.log('logTrack-success', res)
            },
            fail: (res) => {
              console.log('logTrack-fail', res)
            },
          })
        }}>
        log
      </Button>
      <Button
        onClick={() => {
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
        }}>
        beginTransaction
      </Button>
      <Row>
        <Button
          style={{ marginLeft: 8, marginTop: 8, marginBottom: 8, marginRight: 3 }}
          onClick={() => {
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
          }}>
          addSection
        </Button>
        <Button
          style={{ marginLeft: 3, marginTop: 8, marginBottom: 8, marginRight: 3 }}
          onClick={() => {
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
          }}>
          beginIsolatedSection
        </Button>
        <Button
          style={{ marginLeft: 3, marginTop: 8, marginBottom: 8, marginRight: 8 }}
          onClick={() => {
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
          }}>
          endIsolatedSection
        </Button>
      </Row>
      <Button
        style={{ margin: 8 }}
        onClick={() => {
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
        }}>
        end transaction
      </Button>
      <MonitorTrackerDemoBlock></MonitorTrackerDemoBlock>
      <LogDemoBlock></LogDemoBlock>
      <PagePerformanceDemoBlock></PagePerformanceDemoBlock>
    </Layout>
  )
}
