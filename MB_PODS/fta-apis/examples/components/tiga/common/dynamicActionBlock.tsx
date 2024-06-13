import { useThreshContext } from '@fta/hooks'
import { Button, DemoBlock } from '@fta/components/common/display'
import Tiga, { TigaGeneral } from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useEffect, useState } from 'react'
import { Input, Textarea, Text, Toggle } from '@fta/components'

function DynamicActionBlock() {
  const context = useThreshContext()
  const [fileUrl, setFileUrl] = useState(
    'https://devimage.ymm56.com/ymmfile/ymm-cargo-search-app/directConsignorPopTitle.png'
  )
  const [actionName, setactionName] = useState('')
  const [actionEvent, setActionEvent] = useState('')

  return (
    <>
      <DemoBlock label='动态Action' pure>
        <Input
          className='actionname'
          title='action name：'
          placeholder='输入action name'
          value={actionName}
          onInput={(evt) => setactionName?.(evt.detail.value)}
        />

        <Textarea
          title='收到action事件：'
          disabled={false}
          autoHeight={true}
          value={actionEvent}
          style={{ width: '100%' }}
          maxLength={9999}
          onChange={() => {}}
        />

        <Button
          onClick={() => {
            Tiga.Common.registerDynamicAction({
              context: context,
              name: actionName,
              success(res) {
                Taro.showToast({
                  context: context,
                  title: '注册成功',
                })
              },
              fail(res) {
                Taro.showToast({
                  context: context,
                  title: '注册失败',
                })
              },
            }).listener = (res: any) => {
              setActionEvent(JSON.stringify(res))
            }
          }}>
          注册动态Action
        </Button>
      </DemoBlock>
    </>
  )
}

export default DynamicActionBlock
