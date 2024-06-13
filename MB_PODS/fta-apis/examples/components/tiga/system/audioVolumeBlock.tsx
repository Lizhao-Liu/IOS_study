import { DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { Button } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React, { useCallback } from 'react'

export default function AudioVolumeBlock() {
  const context = useThreshContext()
  const onQueryClick = useCallback(() => {
    const usage = 'ring'
    Tiga.System.getAudioVolume({ context, usage }).then((res) => {
      const muteInfo = res.mute == 0 ? '' : ' 静音'
      Taro.showToast({ context, title: `${res.volume * 100}%${muteInfo}` })
    })
  }, [])

  return (
    <DemoBlock label={'音量 & 静音模式'}>
      <Button onClick={onQueryClick}>查询音量</Button>
    </DemoBlock>
  )
}
