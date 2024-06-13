/**
 * title: '弹窗监听'
 * componentName: 'Popup'
 * des: '弹窗管控'
 * previewUrl: 'components/tiga/popup'
 * materialType: 'component'
 * package: '@fta/components-popup'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='popup' qrcode='components/${type}/${name}/index'>
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
    </Layout>
  )
}
