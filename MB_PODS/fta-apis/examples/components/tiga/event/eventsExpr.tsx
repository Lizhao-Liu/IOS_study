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

function EventView2() {
  //   await window?.Truck?.Util?.loadJs('https://devstatic.ymm56.com/common-lib/mb-event/mb-event.20230625.cccd9ce2f91ba74e505c99956223561a.js')

  // let eventListenedTimes = 0;
  const [eventListenedTimes, setEventListenedTimes] = useState(0)
  const eventCenter = TigaGeneral.getEvents(useThreshContext())

  const myListener = useCallback((data: any) => {
    console.log('got event: ' + (data && JSON.stringify(data)))
    setEventListenedTimes((prevTimes) => prevTimes + 1)
  }, [])

  return (
    <DemoBlock label={`Subscriber | got events: ${eventListenedTimes}`} flexDirection='column'>
      <Button
        onClick={() => {
          eventCenter.on(TEST_EVENT, myListener)
        }}>
        subscribe
      </Button>
      <Button
        onClick={() => {
          eventCenter.off(TEST_EVENT, myListener)
        }}>
        unsubscribe
      </Button>
    </DemoBlock>
  )
}

class EventView extends React.Component {
  private eventListenedTimes = 0
  private eventCenter

  constructor(props: {} | Readonly<{}>) {
    super(props)
    this.state = { times: this.eventListenedTimes }
    this.eventCenter = TigaGeneral.getEvents()
  }

  private myListener = (data: any) => {
    console.log('got event: ' + data)
    this.eventListenedTimes++
    this.setState({
      times: this.eventListenedTimes,
    })
  }

  // async componentDidMount(): void {
  //   // todo
  //   await window?.Truck?.Util?.loadJs('https://devstatic.ymm56.com/common-lib/mb-event/mb-event.20230625.cccd9ce2f91ba74e505c99956223561a.js')
  // }

  render() {
    return (
      <DemoBlock
        label={`Subscriber | got events: ${this.eventListenedTimes}`}
        flexDirection='column'>
        <Button
          onClick={() => {
            this.eventCenter.on(TEST_EVENT, this.myListener)
          }}>
          subscribe
        </Button>
        <Button
          onClick={() => {
            this.eventCenter.off(TEST_EVENT, this.myListener)
          }}>
          unsubscribe
        </Button>
      </DemoBlock>
    )
  }
}

function EmitterView() {
  const eventCenter = TigaGeneral.getEvents(useThreshContext)
  return (
    <DemoBlock label='Emitter'>
      <Button
        onClick={() => {
          const eventData = {
            foo: 'bar',
          }
          eventCenter.trigger(TEST_EVENT, eventData)
        }}>
        Emit
      </Button>
    </DemoBlock>
  )
}

export default () => (
  <View>
    <EventView2 />
    <EmitterView />
  </View>
)
