/**
 * title: 'Message push长链'
 * componentName: 'Message'
 * des: 'push和长链消息维护模块'
 * previewUrl: 'components/tiga/message'
 * materialType: 'component'
 * package: '@fta/components-message'
 */
import { Input, Text, Toggle } from '@fta/components'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useCallback, useEffect, useState } from 'react'


// const receiveLongConnCallback = (res) => {
//   const context = useThreshContext()
//   console.log('收到长链消息: ', res.opType, ', longConnMsg:', res)
//   const result = '收到长链消息:' + JSON.stringify(res)
//   Taro.showToast({
//     context: context,
//     title: result,
//   })
// }


export default () => {
  const context = useThreshContext()
  const [notificationType, setNotificationType] = useState('')
  const [opType, setOpType] = useState('')
  const [queuToken, setQueuToken] = useState('')
  const [enableCallback2, setEnableCallback2] = useState(false)

  console.log('组件刷新+++++++++++++++++')

  const receiveLongConnCallback = useCallback(
    (res:any) => {
      console.log('收到长链消息: ', res.opType, ', longConnMsg:', res)
      const result = '收到长链消息:' + JSON.stringify(res)
      Taro.showToast({
        context: context,
        title: result,
      })
    },
    []
  )

  useEffect(() => {
    return () => {
      //Taro.offNetworkStatusChange(receiveLongConnCallback)
    }
  }, [receiveLongConnCallback])

  const receiveLongConnCallback2 = useCallback(
    (res:any) => {
      const context = useThreshContext()
      console.log('回调方法2收到长链消息: ', res.opType, ', longConnMsg:', res)
      const result = '回调方法2收到长链:' + JSON.stringify(res)
      Taro.showToast({
        context: context,
        title: result,
      })
    },
    []
  )

  useEffect(() => {
    return () => {
      //Taro.offNetworkStatusChange(receiveLongConnCallback)
    }
  }, [receiveLongConnCallback2])

  return (
    <Layout title='push长链' style={{ flex: 1 }}>
      <DemoBlock label='push' pure>
        <Input
          className='notificationType'
          placeholder='请输入notificationType'
          value={notificationType}
          onInput={(evt) => setNotificationType?.(evt.detail.value)}
        />

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('注册notificationType')

            Tiga.Message.registerPush({
              context: context,
              notificationType: notificationType,
              consumeMode: 0,
              didReceivePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('收到push消息: ', msg.pushId, ', pushMessage:', msg)
              },
              didDequeuePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('push消息已出队: ', msg.pushId, ', pushMessage:', msg)

                setTimeout(() => {
                  console.log('push消息消费+++++++ 111')
                  const pushMsg = new Tiga.Message.MBPushNotifiable(msg)
                  console.log('push消息消费+++++++ 222')
                  Tiga.Message.pushConsume({
                    context: context,
                    pushId: msg.pushId,

                    notifiable: pushMsg,
                  })
                }, 3000)
              },

              complete(res) {
                console.log('注册notificationType监听 complete结果: ', res)
              },
              fail(res) {
                console.log(
                  '注册notificationType监听, 注册push消息，出队时主动结束消费, fail结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册失败',
                })
              },
              success(res) {
                console.log('注册notificationType监听 success结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '注册成功',
                })
              },
            })
          }}>
          注册push消息，并在出队时消费
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('注册notificationType')

            Tiga.Message.registerPush({
              context: context,
              notificationType: notificationType,
              consumeMode: 0,
              didReceivePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('收到push消息: ', msg.pushId, ', pushMessage:', msg)
              },
              didDequeuePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('push消息已出队: ', msg.pushId, ', pushMessage:', msg)

                setTimeout(() => {
                  console.log('主动结束push消息消费')
                  Tiga.Message.pushQuit({
                    context: context,
                    pushId: msg.pushId,
                  })
                }, 3000)
              },
              fail(res) {
                console.log(
                  '注册notificationType监听, 注册push消息，出队时主动结束消费, fail结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册失败',
                })
              },
              success(res) {
                console.log(
                  '注册notificationType监听, 注册push消息，出队时主动结束消费, success结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册成功',
                })
              },
            })
          }}>
          注册push消息，出队时主动结束消费
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('注册notificationType')

            Tiga.Message.registerPush({
              context: context,
              notificationType: notificationType,
              consumeMode: 1,
              didReceivePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('收到push消息: ', msg.pushId, ', pushMessage:', msg)
                Taro.showModal({
                  context: context,
                  title: msg.title,
                  content: msg.message,
                })
              },
              fail(res) {
                console.log(
                  '注册notificationType监听, 注册push消息，并在收到时直接拦截, fail结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册失败',
                })
              },
              success(res) {
                console.log(
                  '注册notificationType监听, 注册push消息，并在收到时直接拦截, success结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册成功',
                })
              },
            })
          }}>
          注册push消息，并在收到时直接拦截
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('解除注册notificationType: ', notificationType)
            Tiga.Message.removePushListen({
              context: context,
              notificationType: notificationType,
              complete(res) {
                console.log('解除注册push监听 complete结果: ', res)
              },
              success(res) {
                console.log('解除注册push监听 success结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '移除成功',
                })
              },
              fail(res) {
                console.log('解除注册push监听 fail结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '移除失败',
                })
              },
            })
          }}>
          移除push监听
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('注册notificationType: ', notificationType)

            Tiga.Message.registerPush({
              context: context,
              notificationType: notificationType,
              consumeMode: 1,
              didReceivePushMessage: (msg: Tiga.Message.MBPushMessage) => {
                console.log('收到push消息: ', msg.pushId, ', pushMessage:', msg)
                const notification = new Tiga.Message.MBSystemNotification(msg)
                setTimeout(() => {
                  console.log('发系统通知+++++++++++++')
                  Tiga.Message.showSystemNotification({
                    context: context,
                    pushId: msg.pushId,
                    notification: notification,
                  })
                }, 3000)
              },

              success(res) {
                console.log(
                  '注册push消息，并在收到时直接拦截，并调用展示系统通知 success结果: ',
                  res
                )
                Taro.showToast({
                  context: context,
                  title: '注册成功',
                })
              },
              fail(res) {
                console.log('注册push消息，并在收到时直接拦截，并调用展示系统通知 fail结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '注册失败',
                })
              },
            })
          }}>
          注册push消息，并在收到时直接拦截，并调用展示系统通知
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('暂停push消息播报队列 ')
            Tiga.Message.pausePush({
              context: context,
              complete(res) {
                console.log('暂停push消息播报队列 complete结果: ', res)
              },
              success(res) {
                console.log('暂停push消息播报队列 success结果: ', res)
                setQueuToken(res.token)
                Taro.showToast({
                  context: context,
                  title: '暂停成功',
                })
              },
              fail(res) {
                console.log('暂停push消息播报队列 fail结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '暂停失败',
                })
              },
            })
          }}>
          暂停push消息队列
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('恢复push消息队列 ')
            Tiga.Message.resumePush({
              context: context,
              token: queuToken,
              complete(res) {
                console.log('恢复push消息队列 complete结果: ', res)
              },
              success(res) {
                console.log('恢复push消息队列 success结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '恢复队列成功',
                })
              },
              fail(res) {
                console.log('恢复push消息队列 fail结果: ', res)
                Taro.showToast({
                  context: context,
                  title: '恢复队列失败',
                })
              },
            })
          }}>
          恢复push消息队列
        </Button>
      </DemoBlock>

      <DemoBlock label='长链' pure>
        <Input
          className='opType'
          placeholder='请输入opType'
          value={opType}
          onInput={(evt) => setOpType?.(evt.detail.value)}
        />

        <Text> 是否使用回调函数2测试(测试一个opType被多处监听) </Text>
        <Toggle
          active={enableCallback2}
          controls={false}
          onChange={(enable) => setEnableCallback2(enable)}
        />

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('注册 opType: ', opType)
            Tiga.Message.registerLongConnListen({
              context: context,
              opType: opType,
              receiveMessageCallback:
                enableCallback2 === false ? receiveLongConnCallback : receiveLongConnCallback2,
              complete(res) {
                console.log('注册opType监听 complete结果: ', res)
                const result = '注册长链结果:' + JSON.stringify(res)
                Taro.showToast({
                  context: context,
                  title: result,
                })
              },
            })
          }}>
          注册长链消息监听
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('解除注册opType: ', opType)
            Tiga.Message.removeLongConnListen({
              context: context,
              opType: opType,
              complete(res) {
                console.log('解除注册opType complete结果: ', res)
              },
              success(res) {
                console.log('解除注册opType success结果: ', res)
                const result = '移除长链成功:' + JSON.stringify(res)
                Taro.showToast({
                  context: context,
                  title: result,
                })
              },
              fail(res) {
                const result = '移除长链失败:' + JSON.stringify(res)
                Taro.showToast({
                  context: context,
                  title: result,
                })
                console.log('解除注册opType fail结果: ', res)
              },
            })
          }}>
          移除长链消息监听
        </Button>

        <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('解除注册opType: ', opType, ', callback: ', receiveLongConnCallback)
            Tiga.Message.removeLongConnListen({
              context: context,
              opType: opType,
              receiveMessageCallback:
                enableCallback2 === false ? receiveLongConnCallback : receiveLongConnCallback2,
              complete(res) {
                console.log('解除注册opType complete结果: ', res)
                const result = '接触长链结果:' + JSON.stringify(res)
                Taro.showToast({
                  context: context,
                  title: result,
                })
              },
              success(res) {
                console.log('解除注册opType success结果: ', res)
              },
              fail(res) {
                console.log('解除注册opType fail结果: ', res)
              },
            })
          }}>
          根据callback实例 移除长链消息监听
        </Button>
      </DemoBlock>
    </Layout>
  )
}
