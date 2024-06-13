import { EventListener, Events } from './eventApi';

interface MBEventBus {
  subscribeEvent: (event: string, callback: (res: any) => void) => any
  unsubscribeEvent: (event: string, param?: string | number) => any
  sendEvent: (params: { eventName: string; data?: string | number | Record<string, any> }) => any
}

declare global {
  interface Window {
    MBEventBus: MBEventBus
  }
}

class Subscriber {
  proxyToken: string
  realToken: string
  listener: EventListener

  constructor(proxyToken: string, listener: EventListener) {
    this.proxyToken = proxyToken
    this.listener = listener
  }

  listenerWrapper = (event: { data: any }) => {
    this.listener(event.data)
  }
}

function getMBEventBus(): Promise<MBEventBus> {
  return new Promise((resolve, reject) => {
    if (window.MBEventBus) {
      resolve(window.MBEventBus)
    } else {
      setTimeout(() => {
        reject('timeout: No EventBus')
      }, 10000)
      const eventHandler = (event) => {
        if (event.detail && event.detail.ready === 'Fulfilled') {
          window.removeEventListener(event.type, eventHandler)
          resolve(window.MBEventBus)
        }
      }
      window.addEventListener('mbEvent-ready', eventHandler)
    }
  })
}

// export function useEvent(): Events {
//   const [events, setEvents] = useState({});

//   const subscribeEvent = useCallback(
//     (event: string, listener: EventListener): void => {
//       const id = window?.MBEventBus?.subscribeEvent(event, listener);
//       if (events[event]) {
//         events[event] = [...events[event], id];
//       } else {
//         events[event] = [id];
//       }
//       setEvents({ ...events });
//       return id;
//     },
//     [events],
//   );

//   const unsubscribeEvent = useCallback(
//     (event?: string, param?: string | number) => {
//       // 删除单个订阅事件
//       if (event) {
//         if (param) {
//           const i = (events[event] || []).indexOf(param);
//           i > -1 && events[event].splice(i, 1);
//         } else {
//           delete events[event];
//         }
//         setEvents({ ...events });
//         window?.MBEventBus?.unsubscribeEvent(event, param);
//       } else {
//         Object.keys(events).forEach((event: string) => {
//           window?.MBEventBus?.unsubscribeEvent(event);
//         });
//         setEvents({});
//       }
//     },
//     [events],
//   );

//   const sendEvent = (params: {
//     eventName: string;
//     data?: string | number | Record<string, any>;
//   }) => {
//     return window?.MBEventBus?.sendEvent(params) as {
//       code: number;
//       reason: string;
//     };
//   };

//   useEffect(() => {
//     return () => {
//       unsubscribeEvent();
//     };
//   }, []);

//   const res = {
//     subscribeEvent,
//     unsubscribeEvent,
//     sendEvent,
//   }

//   return res;
// }

const TAG = 'Event'

class MicroWebEvents implements Events {
  // private eventBus?: MBEventBus
  private eventBusPromise: Promise<MBEventBus> = getMBEventBus()
  private myMap = new Map<string, Array<Subscriber>>()

  // constructor() {
  //   getMBEventBus().then(res => {
  //     this.eventBus = res
  //   }).catch(e => {
  //     console.error(TAG, e);
  //     this.eventBus = undefined
  //   })
  // }

  on(eventName: string, listener: EventListener) {
    // debugger
    const subscribers = this.myMap.get(eventName) || []
    this.myMap.set(eventName, subscribers)
    for (let subscriber of subscribers) {
      if (subscriber.listener == listener) {
        return subscriber.proxyToken
      }
    }

    const newProxyToken = this._next_id()

    this.eventBusPromise.then(eventBus => {
      const newSubscriber = new Subscriber(newProxyToken, listener)
      subscribers.push(newSubscriber)
      const token = eventBus.subscribeEvent(eventName, listener)
      newSubscriber.realToken = token
    }).catch(reason => {
      return console.error(TAG, reason);
    })

    return newProxyToken
  }

  off(eventName: string, token: string): void
  off(eventName: string, listener: EventListener): void
  off(eventName: string, target: string | EventListener) {
    // debugger
    const subscribers = this.myMap.get(eventName)
    if (!subscribers || subscribers.length == 0) {
      console.warn(TAG, 'No one listening ' + eventName)
      return
    }

    for (let i = 0; i < subscribers.length; i++) {
      let subscriber = subscribers[i]
      if (subscriber.listener == target || subscriber.proxyToken == target) {
        this.eventBusPromise.then(eventBus => {
          eventBus.unsubscribeEvent(eventName, subscriber.realToken)
          console.log(TAG, 'removed one listener on ' + eventName)
        }).catch(reason => {
          console.error(TAG, reason)
        })
        subscribers.splice(i, 1)
        break
      }
    }
  }

  trigger(eventName: string, data: any) {
    this.eventBusPromise.then(eventBus => {
      eventBus.sendEvent({ eventName, data })
    }).catch(reason => {
      console.error(TAG, reason)
    })
  }

  private _inc_id = 0

  private _next_id(): string {
    return (++this._inc_id).toString()
  }
}

export const eventCenter: Events = new MicroWebEvents()

// const eventsRepository = new WeakMap<any, Events>()

export function getEvents(context?: any): Events {
  // let events = eventsRepository.get(context);
  // if (!events) {
  //   events = new MicroWebEvents();
  //   eventsRepository.set(context, events);
  // }
  return eventCenter
}
