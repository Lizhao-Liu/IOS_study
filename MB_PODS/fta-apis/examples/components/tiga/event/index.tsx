/**
 * title: 'Event 事件'
 * componentName: 'Event'
 * des: '事件总线'
 * previewUrl: 'components/tiga/event'
 * materialType: 'component'
 * package: '@fta/components-event'
 */
import { DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import { TigaGeneral } from '@fta/tiga'
import { Button, View } from '@tarojs/components'
import React, { useCallback, useState } from 'react'

const TEST_EVENT = 'event.example.test'

function EventView() {
  const [eventListenedTimes, setEventListenedTimes] = useState(0)
  const events = TigaGeneral.getEvents(useThreshContext())

  const myListener = useCallback(async (data: any) => {
    console.log('got event: ' + (data && JSON.stringify(data)))
  }, [])

  return (
    <DemoBlock label={`Subscriber | got events: ${eventListenedTimes}`} flexDirection='column'>
      <Button
        onClick={() => {
          events.on(TEST_EVENT, myListener)
        }}>
        subscribe
      </Button>
      <Button
        onClick={() => {
          events.off(TEST_EVENT, myListener)
        }}>
        unsubscribe
      </Button>
    </DemoBlock>
  )
}

function EmitterView() {
  const events = TigaGeneral.getEvents(useThreshContext())
  return (
    <DemoBlock label='Emitter'>
      <Button
        onClick={() => {
          const eventData = {
            foo: 'bar',
          }
          events.trigger(TEST_EVENT, eventData)
        }}>
        Emit
      </Button>
    </DemoBlock>
  )
}

export default () => (
  <View>
    <EventView />
    <EmitterView />
  </View>
)
