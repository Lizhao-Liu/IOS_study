import { App as Event } from '@nativex/global-logic-lib'
import { Events } from './eventApi'

class Subscriber {
  token: string
  listener: EventListener

  constructor(token: string, listener: EventListener) {
    this.token = token
    this.listener = listener
  }

  listenerWrapper = (event: { data: any }) => {
    this.listener(event.data)
  }
}

const TAG = 'Event'

class GlobalLogicEvents implements Events {
  private myMap = new Map<string, Map<EventListener, string>>()

  constructor() {}

  on(eventName: string, listener: EventListener) {
    const subscribers = this._event_bind_map[eventName] || []
    this._event_bind_map[eventName] = subscribers
    for (let subscriber of subscribers) {
      if (subscriber.listener == listener) {
        return subscriber.token
      }
    }

    const newSubscriber = new Subscriber(this._next_id(), listener)
    subscribers.push(newSubscriber)

    Event.addListener(eventName, newSubscriber.listenerWrapper)
    // TigaBridge.call(this.context, 'app.event.subscribe', { eventName });

    return newSubscriber.token
  }

  off(eventName: string, token: string): void
  off(eventName: string, listener: EventListener): void
  off(eventName: string, target: string | EventListener) {
    const subscribers = this._event_bind_map[eventName]
    console.log(TAG, subscribers)
    if (!subscribers || subscribers.length == 0) {
      console.warn(TAG, 'No one listening ' + eventName)
      return
    }

    for (let i = 0; i < subscribers.length; i++) {
      let subscriber = subscribers[i]
      if (subscriber.listener == target || subscriber.token == target) {
        Event.removeListener(eventName, subscriber.listenerWrapper)
        console.log(TAG, 'removed one listener on ' + eventName)
        // if (subscribers.length === 1) {
        // TigaBridge.call(this.context, 'app.event.unsubscribe', { eventName });
        // this._event_bind_map[eventName] = [];
        // }
        subscribers.splice(i, 1)
        break
      }
    }
  }

  trigger(eventName: string, data: any) {
    console.log('trigger ' + eventName + ' ' + (data && JSON.stringify(data)))
    Event.emit(eventName, data)
    // TigaBridge.call(this.context, 'app.event.post', {
    //   eventName: eventName,
    //   data: data
    // })
  }

  private _event_bind_map: Record<string, Array<Subscriber>> = {}
  private _inc_id = 0

  private _next_id(): string {
    return (++this._inc_id).toString()
  }
}

export const eventCenter: Events = new GlobalLogicEvents()

export function getEvents(context: any): Events {
  return eventCenter
}
