import { Events } from './eventApi'
import { TigaBridge } from './TigaBridge'

class Subscriber {
  token: string
  listener: EventListener
}

class RnEvents implements Events {
  private myMap = new Map<string, Map<EventListener, string>>()
  private context = null

  on(eventName: string, listener: EventListener) {
    TigaBridge.call(this.context, 'app.event.subscribe', { eventName })

    const subscribes = this._event_bind_map[eventName] || []
    this._event_bind_map[eventName] = subscribes
    for (let subscriber of subscribes) {
      if (subscriber.listener == listener) {
        return subscriber.token
      }
    }
    const newSubscriber: Subscriber = { token: this._next_id(), listener: listener }
    subscribes.push(newSubscriber)
    return newSubscriber.token
  }

  off(eventName: string, token: string): void
  off(eventName: string, listener: EventListener): void
  off(eventName: string, target: string | EventListener) {
    if (!this._event_bind_map[eventName]) {
      return
    }

    const subscribers = this._event_bind_map[eventName]
    for (let i = 0; i < subscribers.length; i++) {
      let subscriber = subscribers[i]
      if (subscriber.listener == target || subscriber.token == target) {
        if (subscribers.length === 1) {
          TigaBridge.call(this.context, 'app.event.unsubscribe', { eventName })
          this._event_bind_map[eventName] = []
        }
        subscribers.splice(i, 1)
        break
      }
    }
  }

  trigger(eventName: string, data: any) {
    TigaBridge.call(this.context, 'app.event.post', {
      eventName: eventName,
      data: data,
    })
  }

  private _event_bind_map: Record<string, Array<Subscriber>> = {}
  private _inc_id = 0

  private _next_id(): string {
    return (++this._inc_id).toString()
  }
}

export const eventCenter: Events = new RnEvents()

// const eventsRepository = new WeakMap<any, Events>();

export function getEvents(context?: any): Events {
  // let events = eventsRepository.get(context);
  // if (!events) {
  // events = new RnEvents(context);
  // eventsRepository.set(context, events);
  // }
  return new RnEvents()
}
