import { useThreshContext } from '@fta/hooks'
import { Button, DemoBlock } from '@fta/components/common/display'
import Tiga, { TigaGeneral } from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useEffect, useState } from 'react'
import { Input, Textarea, Text, Toggle } from '@fta/components'

function DownloadDemoBlock() {
  const context = useThreshContext()
  const [fileUrl, setFileUrl] = useState(
    'https://devimage.ymm56.com/ymmfile/ymm-cargo-search-app/directConsignorPopTitle.png'
  )
  const [localPath, setLocalPath] = useState()
  const [downresult, setDownresult] = useState('')
  const [downprogress, setDownprogress] = useState('')
  const [relativeUrl, setRelativeUrl] = useState('')
  const [absoluteUrl, setAbsoluteUrl] = useState('')
  const [bizType, setBizType] = useState('')

  return (
    <>
      <DemoBlock label='Taro-下载文件接口' pure>
        <Input
          className='keyname'
          placeholder='文件网络url, 不可为空'
          value={fileUrl}
          onInput={(evt) => setFileUrl?.(evt.detail.value)}
        />

        <Input
          className='keyname'
          placeholder='文件存储路径, 可以为空, 不传将存储到临时目录'
          value={localPath}
          onInput={(evt) => setLocalPath?.(evt.detail.value)}
        />

        <Button
          onClick={() => {
            Taro.downloadFile({
              context: context,
              url: fileUrl,
              filePath: localPath,
              success(result) {
                console.log('下载文件 success: ', result)
                setDownresult(JSON.stringify(result))
              },
              fail(res) {
                console.log('下载文件 failed: ', res)
                setDownresult(JSON.stringify(res))
              },
              complete(res) {
                console.log('下载文件 complete: ', res)
              },
            })
          }}>
          下载文件
        </Button>

        <Textarea
          disabled={false}
          autoHeight={true}
          value={downresult}
          style={{ margin: 8 }}
          maxLength='9999'
          onChange={() => {}}
        />

        <Textarea
          disabled={false}
          autoHeight={true}
          value={'下载进度: ' + downprogress}
          style={{ margin: 8 }}
          maxLength='9999'
          onChange={() => {}}
        />

        <Button
          onClick={() => {
            // const downloadTask =
            // Tiga.Network.downloadFile({
            //   context: context,
            //   url: fileUrl,
            //   filePath: localPath,
            //   success(result) {
            //     console.log('载文件-进度监听 success: ', result)
            //     Taro.showToast({
            //       context: context,
            //       title: '下载成功: '+ JSON.stringify(result)
            //     })
            //   },
            //   fail(res) {
            //     console.log('载文件-进度监听 failed: ', res)
            //     Taro.showToast({
            //       context: context,
            //       title: '下载失败: '+ JSON.stringify(res)
            //     })
            //   },
            //   complete(res) {
            //     console.log('载文件-进度监听 complete: ', res)
            //   }
            // })
            const downloadTask = Taro.downloadFile({
              context: context,
              url: fileUrl,
              filePath: localPath,
              success(result) {
                console.log('下载文件-进度监听 success: ', result)
                setDownresult(JSON.stringify(result))
              },
              fail(res) {
                console.log('下载文件-进度监听 failed: ', res)
                setDownresult(JSON.stringify(res))
              },
              complete(res) {
                console.log('下载文件-进度监听 complete: ', res)
              },
            })

            downloadTask.onProgressUpdate((progress) => {
              setDownprogress(
                '下载进度：' +
                  progress.progress +
                  ' 总大小: ' +
                  progress.totalBytesExpectedToWrite +
                  ' 当前下载大小: ' +
                  progress.totalBytesWritten
              )
            })
          }}>
          下载文件-下载进度监听
        </Button>

        <Button
          onClick={() => {
            const downloadTask = Taro.downloadFile({
              context: context,
              url: fileUrl,
              filePath: localPath,
              success(result) {
                console.log('下载文件-取消下载 success: ', result)
                Taro.showToast({
                  context: context,
                  title: '下载成功: ' + JSON.stringify(result),
                })
              },
              fail(res) {
                console.log('下载文件-取消下载 failed: ', res)
                Taro.showToast({
                  context: context,
                  title: '下载失败: ' + JSON.stringify(res),
                })
              },
              complete(res) {
                console.log('下载文件-取消下载 complete: ', res)
              },
            })
            downloadTask.onProgressUpdate((progress) => {
              setDownprogress(
                '下载进度：' +
                  progress.progress +
                  ' 总大小: ' +
                  progress.totalBytesExpectedToWrite +
                  ' 当前下载大小: ' +
                  progress.totalBytesWritten
              )
            })
            downloadTask.abort()
            Taro.showToast({ context: context, title: '取消下载' })
          }}>
          下载文件-取消下载
        </Button>

        <Input
          name='uploadbizType'
          title='bizType: '
          type='text'
          placeholder='输入biztype'
          value={bizType}
          onInput={(evt) => setBizType?.(evt.detail.value)}
        />

        <Input
          className='relativekey'
          title='相对路径：'
          placeholder='输入相对路径'
          value={relativeUrl}
          onInput={(evt) => setRelativeUrl?.(evt.detail.value)}
        />

        <Textarea
          title='绝对路径结果：'
          disabled={false}
          autoHeight={true}
          value={absoluteUrl}
          style={{ width: '100%' }}
          maxLength={9999}
          onChange={() => {}}
        />

        <Button
          onClick={() => {
            Tiga.Network.batchGetFileAbsoluteUrl({
              context: context,
              requests: [
                {
                  key: relativeUrl,
                  bizType: bizType,
                },
              ],
              success(result) {
                console.log('上传文件-获取绝对路径 success: ', result)
                setAbsoluteUrl(JSON.stringify(result))
                Taro.showToast({
                  context: context,
                  title: '获取绝对路径成功: ' + JSON.stringify(result),
                })
              },
              fail(res) {
                console.log('上传文件-获取绝对路径 failed: ', res)
                Taro.showToast({
                  context: context,
                  title: '获取绝对路径失败: ' + JSON.stringify(res),
                })
              },
              complete(res) {
                console.log('上传文件-获取绝对路径 complete: ', res)
              },
            })
          }}>
          上传文件-获取绝对路径
        </Button>
      </DemoBlock>
    </>
  )
}

export default DownloadDemoBlock
