export type EventListener = (eventData: any) => void

export interface Events {
  /**
   * 订阅事件
   * @param eventName 事件名
   * @param listener 事件触发回调
   * @returns 订阅记录 Token，用于取消订阅
   */
  on: (eventName: string, listener: EventListener) => string

  /**
   * 取消订阅
   * @param eventName 事件名
   * @param token 订阅记录 Token
   */
  off(eventName: string, token: string): void
  /**
   * 取消订阅
   * @param eventName 事件名
   * @param listener 订阅时提供的回调
   */
  off(eventName: string, listener: EventListener): void

  // trigger: (eventName: string, data) => void
  /**
   * 触发事件
   * @param eventName 事件名
   * @param data 事件数据
   */
  trigger(eventName: string, data): void
}

export { eventCenter, getEvents } from './eventImpl'
