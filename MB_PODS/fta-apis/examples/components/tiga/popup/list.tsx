/**
 * title: 'Popup 弹窗管控'
 * componentName: 'Popup'
 * des: '弹窗管控'
 * previewUrl: 'components/tiga/popup'
 * materialType: 'component'
 * package: '@fta/components-popup'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { Text } from '@tarojs/components'

import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React, { useState } from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()
  const [popupId, setPopupId] = useState('8888')
  return (
    <Layout title='popup' qrcode='components/${type}/${name}/index'>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.finish({
              context: context,
              popupCode: 1234,
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          弹窗结束
        </Button>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              Tiga.Popup.track({
                context: context,
                type: 2,
                popupCode: 1234,
              })
                .then((res) => {
                  console.log(res)
                })
                .catch((err) => {
                  console.log(err)
                })
            }}>
            弹窗埋点
          </Button>
        </DemoBlock>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.insertData({
              context: context,
              popupCode: 8888,
              pageList: ['shippermain'],
              pageInfoList: [
                {
                  page: 'shippermain',
                  popupCode: 1234,
                },
                {
                  page: 'myorders',
                  popupCode: 5678,
                },
              ],
              interfaceName: '/test/data',
              data: '1324141',
              isRegisterDialog: false,
              show(data) {
                console.log(JSON.stringify(data))
              },
            })
              .then((res) => {
                console.log(JSON.stringify(res))
              })
              .catch((err) => {
                console.log(JSON.stringify(err))
              })
          }}>
          添加自定义弹窗数据
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.registerDialogMonitor({
              context: context,
              interfaceName: '/test/data',
              requestParams: { a: 'b' },
              pageList: [],
              show(data) {
                console.log('展示弹窗')
                console.log(data)
              },
            })
              .then((res) => {
                setPopupId(res.dialogId ? res.dialogId : '')
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          注册弹窗信息监听(单个)
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.removeDialogMonitor({
              context: context,
              dialogId: popupId,
            })
              .then((res) => {
                console.log(JSON.stringify(res))
              })
              .catch((err) => {
                console.log(JSON.stringify(err))
              })
          }}>
          移除弹窗信息监听
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.updateDialogRequestParams({
              context: context,
              dialogId: popupId,
              requestParams: {
                a: 'mmm',
              },
              page: 'mine',
            })
              .then((res) => {
                console.log(JSON.stringify(res))
              })
              .catch((err) => {
                console.log(JSON.stringify(err))
              })
          }}>
          更新弹窗实例的请求参数
        </Button>
      </DemoBlock>
      <DemoBlock label=''>
        <Text>当前的弹窗 id：{popupId}</Text>
      </DemoBlock>
    </Layout>
  )
}
