import { Event } from '@thresh/thresh-lib'
import { Events } from './eventApi'
import { getHeadlessServiceContext } from './tigaHeadlessService'

class Subscriber {
  token: string
  listener: EventListener
  strictContainerId?: string

  private static EVENT_NAVIGATOR_POP = 'navigator.pop'

  constructor(token: string, listener: EventListener, eventName: string, containerId: string) {
    this.token = token
    this.listener = listener
    if (eventName == Subscriber.EVENT_NAVIGATOR_POP) {
      this.strictContainerId = containerId
    }
  }

  listenerWrapper = (event: { data: any }, containerId: string) => {
    if (this.strictContainerId && this.strictContainerId != containerId) {
      console.log('ignored event', event, this.strictContainerId, containerId)
      return
    }
    this.listener(event.data)
  }
}

const TAG = 'Event'

class ThreshEvents implements Events {
  protected context?: any

  constructor(context?: any) {
    // console.log(TAG, 'construct new ThreshEvent');
    this.context = context
  }

  async getContext(): Promise<any> {
    return Promise.resolve(this.context)
  }

  on(eventName: string, listener: EventListener) {
    const subscribers = this._event_bind_map[eventName] || []
    this._event_bind_map[eventName] = subscribers
    for (let subscriber of subscribers) {
      if (subscriber.listener == listener) {
        return subscriber.token
      }
    }

    const newToken = this._next_id()

    this.getContext().then((ctx) => {
      if (ctx === null) {
        console.error(TAG, `Cannot subscribe event ${eventName} because bundle name is not set`)
        return
      }
      const newSubscriber = new Subscriber(newToken, listener, eventName, getContainerId(ctx))
      subscribers.push(newSubscriber)
      Event.addMessageEventListener(ctx, eventName, newSubscriber.listenerWrapper)
    })

    // TigaBridge.call(this.context, 'app.event.subscribe', { eventName });

    return newToken
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
        this.getContext().then((ctx) => {
          Event.removeMessage(ctx, eventName, subscriber.listenerWrapper)
          console.log(TAG, 'removed one listener on ' + eventName)
        })
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
    this.getContext().then((ctx) => {
      Event.fireMessage(ctx, eventName, data)
    })
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

class EngineEvents extends ThreshEvents {
  constructor() {
    super()
  }

  async getContext(): Promise<any> {
    return getHeadlessServiceContext()
  }
}

export const eventCenter: Events = new EngineEvents()

const eventsRepository = new WeakMap<any, Events>()

export function getEvents(context: any): Events {
  let events = eventsRepository.get(context)
  if (!events) {
    events = new ThreshEvents(context)
    eventsRepository.set(context, events)
  }
  return events
  // return new ThreshEvents(context);
}

interface ContainerContext {
  __contextId__: string
}

function getContainerId(context: any) {
  return (context as ContainerContext).__contextId__
}
