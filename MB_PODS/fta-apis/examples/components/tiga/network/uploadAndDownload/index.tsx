/**
 * title: 'Network 网络库'
 * componentName: 'Network'
 * des: '网络相关'
 * previewUrl: 'components/tiga/network'
 * materialType: 'component'
 * package: '@fta/components-network'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'

import { Input, Textarea } from '@fta/components'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'
import DownloadDemoBlock from '../downloadDemoBlock'

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
    <Layout title='network' qrcode='components/tiga/network/upload/index' style={{ flex: 1 }}>
      <DemoBlock label='上传文件数据' pure>
        <Input
          name='uploadserver'
          title='服务器(默认1阿里oss; 2华为obs): '
          type='number'
          placeholder='输入服务器'
          value={ossServer.toString()}
          onInput={(evt) => setOssServer?.(Number(evt.detail.value))}
        />
        <Input
          name='uploadtimeout'
          title='超时(毫秒): '
          type='number'
          placeholder='输入超时时间 毫秒'
          value={uploadTimeOut.toString()}
          onInput={(evt) => setUploadTimeOut?.(Number(evt.detail.value))}
        />
        <Input
          name='uploadbizType'
          title='bizType: '
          type='text'
          placeholder='输入biztype'
          value={bizType}
          onInput={(evt) => setBizType?.(evt.detail.value)}
        />
        <Input
          name='uploadlocalPath'
          title='本地path: '
          type='text'
          placeholder='输入本地path'
          value={localPath}
          onInput={(evt) => setLocalPath?.(evt.detail.value)}
        />
        <Input
          name='uploadspecifyKey'
          title='指定路径: '
          type='text'
          placeholder='输入上传指定路径'
          value={specifyKey}
          onInput={(evt) => setSpecifyKey?.(evt.detail.value)}
        />
        <Textarea
          disabled={false}
          autoHeight={true}
          value={uploadResultUrl}
          style={{ width: '100%' }}
          maxLength={9999}
          onChange={() => {}}
        />
      </DemoBlock>
      <DemoBlock label='上传文件' pure>
        <Button
          onClick={() => {
            setUploadResultUrl('')
            Tiga.Network.uploadFiles({
              context: context,
              timeout: uploadTimeOut,
              files: [
                {
                  bizType: bizType,
                  localPath: localPath,
                  specifyKey: specifyKey,
                },
                // ,
                // {
                //   bizType: 'app_resources',
                //   localPath:
                //     '/var/mobile/Containers/Data/Application/5BF587DE-CE7B-4596-AD33-2B8A0AFA2264/Documents/DATABASE_SHIPPER.sqlite',
                // },
              ],
              complete(res) {
                console.log('uploadFiles complete: ', res)
              },
              success(res) {
                setUploadResultUrl(JSON.stringify(res.ossUrls))
                Taro.showToast({ context: context, title: res.reason ?? '上传成功' })
                console.log('uploadFiles success: ', res)
              },
              fail(res) {
                Taro.showToast({ context: context, title: res.reason ?? '上传失败' })
                setUploadResultUrl(res.reason ?? '上传失败')
                console.log('uploadFiles fail: ', res)
              },
            })
          }}>
          上传文件
        </Button>
      </DemoBlock>

      <DemoBlock label='上传文件 - await' pure>
        <Button
          onClick={async () => {
            setUploadResultUrl('')
            const res = await Tiga.Network.uploadFiles({
              context: context,
              timeout: uploadTimeOut,
              files: [
                {
                  bizType: bizType,
                  localPath: localPath,
                  specifyKey: specifyKey,
                },
                // ,
                // {
                //   bizType: 'app_resources',
                //   localPath:
                //     '/var/mobile/Containers/Data/Application/5BF587DE-CE7B-4596-AD33-2B8A0AFA2264/Documents/DATABASE_SHIPPER.sqlite',
                // },
              ],
            }).catch((error) => {
              console.log('上传文件await.error: ', error)
              return error
            })
            if (res.code != 0) {
              Taro.showToast({ context: context, title: res.reason ?? '上传失败' })
              setUploadResultUrl(res.reason ?? '上传失败')
            } else {
              Taro.showToast({ context: context, title: res.reason ?? '上传成功' })
              setUploadResultUrl(JSON.stringify(res.ossUrls))
            }
            console.log('上传文件await: ', res)
          }}>
          上传文件 - await
        </Button>
      </DemoBlock>

      <DemoBlock label='上传文件 - 进度监听' pure>
        <Textarea
          disabled={false}
          autoHeight={true}
          value={'上传进度:' + uploadProgress.toString()}
          style={{ width: '100%' }}
          onChange={() => {}}
        />

        <Button
          onClick={() => {
            setUploadResultUrl('')
            setUploadProgress(0)
            const uploadtask = Tiga.Network.uploadFiles({
              context: context,
              timeout: uploadTimeOut,
              files: [
                {
                  bizType: bizType,
                  localPath: localPath,
                  specifyKey: specifyKey,
                },
                // ,
                // {
                //   bizType: 'app_resources',
                //   localPath:
                //     '/var/mobile/Containers/Data/Application/5BF587DE-CE7B-4596-AD33-2B8A0AFA2264/Documents/DATABASE_SHIPPER.sqlite',
                // },
              ],
              complete(res) {
                console.log('uploadFiles 进度监听 complete: ', res)
              },
              success(res) {
                Taro.showToast({ context: context, title: res.reason ?? '上传成功' })
                setUploadResultUrl(JSON.stringify(res.ossUrls))
                console.log('uploadFiles 进度监听 success: ', res)
              },
              fail(res) {
                Taro.showToast({ context: context, title: res.reason ?? '上传失败' })
                setUploadResultUrl(res.reason ?? '上传失败')
                console.log('uploadFiles 进度监听 fail: ', res)
              },
            })
            uploadtask.onProgressUpdate((progress) => {
              setUploadProgress(progress.percent)
              console.log('uploadFiles 进度监听, 上传进度 progress: ', progress.percent)
            })
          }}>
          上传文件 - 进度监听
        </Button>
      </DemoBlock>

      <DemoBlock label='取消上传文件' pure>
        <Button
          onClick={() => {
            const uploadtask = Tiga.Network.uploadFiles({
              context: context,
              timeout: uploadTimeOut,
              files: [
                {
                  bizType: bizType,
                  localPath: localPath,
                  specifyKey: specifyKey,
                },
                // ,
                // {
                //   bizType: 'app_resources',
                //   localPath:
                //     '/var/mobile/Containers/Data/Application/DAE8F497-4D70-4D61-9BE3-413CE3B2D88B/Documents/DATABASE_SHIPPER.sqlite',
                // },
              ],
              complete(res) {
                console.log('uploadFiles 取消 complete: ', res)
              },
              success(res) {
                uploadtask.abort()

                console.log('uploadFiles 取消 success: ', res)
              },
              fail(res) {
                console.log('uploadFiles 取消 fail: ', res)
              },
            })

            console.log('取消上传文件!')
            Taro.showToast({ context: context, title: '取消上传' })
          }}>
          取消上传文件
        </Button>
      </DemoBlock>

      <DownloadDemoBlock></DownloadDemoBlock>
    </Layout>
  )
}
