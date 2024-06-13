import { Input } from '@fta/components'
import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'

import React, { useState } from 'react'

export default function FileTransferBlock() {
  const context = useThreshContext()

  const [srcPath, setSrcPath] = useState('')
  const [srcFormat, setSrcFormat] = useState('amr')
  const [dstPath, setDstPath] = useState()
  const [dstFormat, setDstFormat] = useState('wav')


  return (
    <DemoBlock label='文件转码' pure>
      <Input
          className='srcPath'
          placeholder='请输入源文件路径'
          value={srcPath}
          maxlength={9999}
          onInput={(evt) => setSrcPath?.(evt.detail.value)}
      />
      <Input
          className='srcFormat'
          placeholder='请输入源文件格式(amr/wav)'
          value={srcFormat}
          onInput={(evt) => setSrcFormat?.(evt.detail.value)}
      />
      <Input
          className='dstPath'
          placeholder='请输入目标文件路径'
          value={dstPath}
          maxlength={9999}
          onInput={(evt) => setDstPath?.(evt.detail.value)}
      />
      <Input
          className='dstFormat'
          placeholder='请输入目标文件路径(amr/wav)'
          value={dstFormat}
          onInput={(evt) => setDstFormat?.(evt.detail.value)}
      />

      <Button
          style={{ margin: 8 }}
          onClick={() => {
            console.log('开始转码: ', srcPath)
            Tiga.Media.filetransfer({
              context: context,
              srcPath: srcPath,
              srcFormat: srcFormat == 'amr' ? 'amr' : 'wav',
              dstPath: dstPath,
              dstFormat: dstFormat == 'wav' ? 'wav' : 'amr',
              success(res) {
                const message = '转码成功' + res.dstPath
                console.log(message)
                Taro.showToast({
                  context: context,
                  title: message,
                })
              },
              fail(res) {
                const message = '转码失败' + res.reason
                console.log(message)
                Taro.showToast({
                  context: context,
                  title: message,
                })
              },
            })
            // Tiga.Media.filetransfer

          }}>
          转码
        </Button>
    </DemoBlock>
  )
}
