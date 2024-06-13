/**
 * title: 'Ui ui'
 * componentName: 'Ui'
 * des: 'ui'
 * previewUrl: 'components/tiga/ui'
 * materialType: 'component'
 * package: '@fta/components-ui'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'
import './index.scss'

export default () => {
  const context = useThreshContext()
  return (
    <Layout title='UI' qrcode='components/tiga/ui/index'>
      <DemoBlock label='show loading without mask' pure>
        <Button
          onClick={() =>
            Taro.showLoading({
              title: '加载中',
              mask: false,
              context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                console.log('fail:', res)
              },
              success(res) {
                console.log('success:', res)
              },
            })
          }>
          show loading
        </Button>
      </DemoBlock>
      <DemoBlock label='show loading with mask, auto dismiss in 5s' pure>
        <Button
          onClick={() =>
            Taro.showLoading({
              title: 'loading 自动消失',
              mask: true,
              context,
            })
              .then((res) => {
                setTimeout(() => {
                  Taro.hideLoading({ context })
                  console.log(res)
                }, 5000)
              })
              .catch((e) => {
                console.log('error' + e)
                Taro.hideLoading({ context })
              })
          }>
          show loading
        </Button>
      </DemoBlock>

      <DemoBlock label='hide loading' pure>
        <Button onClick={() => Taro.hideLoading({ context })}>hide loading</Button>
      </DemoBlock>

      <DemoBlock label='show toast near the bottom without mask' pure>
        <Button
          onClick={() =>
            Taro.showToast({
              title: '居下的toast',
              mask: false,
              gravity: 2,
              context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                console.log('fail:', res)
              },
              success(res) {
                console.log('success:', res)
              },
            }).catch((e) => {
              console.log(e)
            })
          }>
          show toast
        </Button>
      </DemoBlock>
      <DemoBlock label='show toast with mask, auto dismiss in 3s' pure>
        <Button
          onClick={() =>
            Taro.showToast({
              title: '居中的toast',
              mask: true,
              duration: 3000,
              icon: 'success',
              context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                console.log('fail:', res)
              },
              success(res) {
                console.log('success:', res)
              },
            }).catch((e) => {
              console.log(e)
            })
          }>
          show toast
        </Button>
      </DemoBlock>

      <DemoBlock label='hide toast' pure>
        <Button onClick={() => Taro.hideToast({ context })}>hide toast</Button>
      </DemoBlock>

      <DemoBlock label='show action sheet with two options' pure>
        <Button
          onClick={() =>
            Taro.showActionSheet({
              itemList: ['test 1', 'test 2'],
              alertText: 'test',
              context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                console.log('fail:', res)
              },
              success(res) {
                console.log('success:', res)
              },
            }).catch((e) => {
              console.log(e)
            })
          }>
          show action sheet
        </Button>
      </DemoBlock>

      <DemoBlock label='show modal' pure>
        <Button
          onClick={() =>
            Taro.showModal({
              content: '描述文案',
              title: '对话框标题',
              showCancel: true,
              context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                console.log('fail:', res)
              },
              success(res) {
                console.log('success:', res)
              },
            })
          }>
          show modal
        </Button>
      </DemoBlock>
      <DemoBlock label='show info dialog' pure>
        <Button
          onClick={() =>
            Tiga.UI.showInfoDialog({
              content: '描述文案',
              title: '对话框标题',
              context,
              buttons: [
                {
                  text: '选项一',
                  color: '#000000',
                },
                {
                  text: '选项二',
                  color: '#576B95',
                },
              ],
              showCloseBtn: true,
              complete(res: any) {
                console.log('complete:', res)
              },
              fail(res: any) {
                console.log('fail:', res)
              },
              success(res: any) {
                console.log('success:', res)
              },
              buttonOrientation: 1,
              canceledOnTouchOutside: true,
            })
          }>
          show info dialog
        </Button>
      </DemoBlock>
      <DemoBlock label='show status dialog' pure>
        <Button
          onClick={() =>
            Tiga.UI.showStatusDialog({
              content: '描述文案',
              title: '对话框标题',
              context,
              buttons: [
                {
                  text: '知道了',
                },
              ],
              statusIcon: 'https://imagecdn.ymm56.com/ymmfile/static/image/trade/success.png',
              buttonOrientation: 0,
              canceledOnTouchOutside: true,
              complete(res: any) {
                console.log('complete:', res)
              },
              fail(res: any) {
                console.log('fail:', res)
              },
              success(res: any) {
                console.log('success:', res)
              },
            })
          }>
          show status dialog
        </Button>
      </DemoBlock>
    </Layout>
  )
}
