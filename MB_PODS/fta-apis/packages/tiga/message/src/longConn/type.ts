import { TigaGeneral } from '@fta/tiga-util'

export interface MBLongConnHandleOption extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 长链业务类型名
   */
  opType: string

  /**
   * 收到长链消息回调
   */
  receiveMessageCallback: ReceiveLongConnMessageCallback
}

/** 收到长链回调 */
export type ReceiveLongConnMessageCallback = (msg: MBLongConnMessage) => void

export interface MBLongConnMessage {
  /** 长链业务类型名 */
  opType: string
  /** 业务字段 */
  msgContent?: any
}

export interface MBRemoveLongConnListenOption
  extends TigaGeneral.Option<TigaGeneral.CallbackResult> {
  /**
   * 长链业务类型名
   */
  opType: string

  /**
   * 需要传入监听长链时同一个回调函数实例，将会移除实例对应的监听；
   * 如果不传则会移除opType对应的所有监听
   */
  receiveMessageCallback?: ReceiveLongConnMessageCallback
}
