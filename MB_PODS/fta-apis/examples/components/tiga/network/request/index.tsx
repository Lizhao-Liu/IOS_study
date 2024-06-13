/**
 * title: 'Network 网络库'
 * componentName: 'Network'
 * des: '网络相关'
 * previewUrl: 'components/tiga/network'
 * materialType: 'component'
 * package: '@fta/components-network'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'

import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React, { useState } from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  const [uploadResultUrl, setUploadResultUrl] = useState('')
  const [ossServer, setOssServer] = useState(1)
  const [uploadTimeOut, setUploadTimeOut] = useState(3000)
  const [bizType, setBizType] = useState('app_resources')
  const [localPath, setLocalPath] = useState('')
  const [specifyKey, setSpecifyKey] = useState('')
  const [uploadProgress, setUploadProgress] = useState(0)

  return (
    <Layout title='network' qrcode='components/tiga/network/request/index' style={{ flex: 1 }}>
      <DemoBlock label='触发网络请求' pure>
        <Button
          onClick={() => {
            console.log('开始请求')
            Tiga.Network.request({
              context: context,
              method: 'POST',
              responseType: 'data',
              url: '/ymm-userCenter-app/authenticate/checkCertifyStatus999',
              data: {
                sceneId: 2,
              },
            })
              .then((res) => {
                console.log('then 成功:', res)
              })
              .catch((err) => {
                console.log('catch 失败:', err)
              })
          }}>
          网络请求（运满满）
        </Button>
      </DemoBlock>

      <DemoBlock label='触发网络请求' pure>
        <Button
          onClick={() => {
            console.log('开始请求')
            Tiga.Network.request({
              context: context,
              useDispatch: true,
              url: '/ymm-userCenter-app/authenticate/checkCertifyStatus444',
              data: {
                sceneId: 2,
              },
            })
              .then((res) => {
                console.log('then成功:', res)
              })
              .catch((err) => {
                console.log('catch失败:', err)
              })
          }}>
          网络请求（货车帮）
        </Button>
      </DemoBlock>

      <DemoBlock label='触发网络请求' pure>
        <Button
          onClick={() => {
            console.log('开始请求')
            Tiga.Network.request({
              context: context,
              responseType: 'data',
              url: '/ymm-uc-app/layout/getUserInfo',
              data: {
                sceneId: 2,
              },
            })
              .then((res) => {
                console.log('then成功:', res)
              })
              .catch((err) => {
                console.log('catch失败:', err)
              })
          }}>
          网络请求(response 中含有 data)
        </Button>
      </DemoBlock>

      <DemoBlock label='触发网络请求' pure>
        <Button
          onClick={async () => {
            try {
              const res = await Tiga.Network.request({
                context: context,
                url: '/ymm-userCenter-app/authenticate/checkCertifyStatus',
                data: {
                  sceneId: 2,
                },
              })
              console.log(res)
            } catch (error) {
              console.log(error)
            }
          }}>
          网络请求 - await
        </Button>
      </DemoBlock>

      <DemoBlock label='取消网络请求' pure>
        <Button
          onClick={() => {
            const task = Tiga.Network.request({
              context: context,
              url: '/ymm-userCenter-app/authenticate/checkCertifyStatus',
              data: {
                sceneId: 2,
              },
              complete(res) {
                console.log('完成:', JSON.stringify(res))
              },
              success(res) {
                console.log('成功:', JSON.stringify(res))
              },
              fail(error) {
                console.log('失败:', JSON.stringify(error))
              },
            })
            // if (task.abort) {
            task.abort()
            // }
          }}>
          取消请求
        </Button>
      </DemoBlock>
    </Layout>
  )
}
