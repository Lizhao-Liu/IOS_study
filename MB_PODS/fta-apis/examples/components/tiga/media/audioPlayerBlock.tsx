import { DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import { Button } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React, { useCallback, useEffect, useState } from 'react'

const SRC_ARR = [
  'https://qaimage.ymm56.com/ymmfile/scheduler-driver-voice/20210323/52489de3-746c-4d2b-bd6c-cbd7ddedd94d.mp3',
  'https://devimage.ymm56.com/ymmfile/ymm-cargo-search-app/20231128/a5511cb9-74a3-48e3-90fd-767d78e73e77.mp3'
]

export default function AudioPlayerBlock() {
  const context = useThreshContext()
  const [audioContext, setAudioContext] = useState(Taro.createInnerAudioContext)
  const [srcIndex, setSrcIndex] = useState(0)

  useEffect(() => {
    audioContext.src = SRC_ARR[srcIndex]
    // audioContext.loop = true
    audioContext.onCanplay(() => {
      setPlayEnabled(true)
      setPauseEnabled(false)
      setStopEnabled(false)
      setSrcEnabled(true)
    })
    audioContext.onPlay(() => {
      setPlayEnabled(false)
      setPauseEnabled(true)
      setStopEnabled(true)
      setSrcEnabled(false)
    })
    audioContext.onPause(() => {
      setPlayEnabled(true)
      setPauseEnabled(false)
      setStopEnabled(true)
      setSrcEnabled(false)
    })
    audioContext.onStop(() => {
      setPlayEnabled(true)
      setPauseEnabled(false)
      setStopEnabled(false)
      setSrcEnabled(true)
    })
    audioContext.onEnded(() => {
      setPlayEnabled(true)
      setPauseEnabled(false)
      setStopEnabled(true)
      setSrcEnabled(false)
    })
    return () => {
      audioContext.destroy()
    }
  }, [])
  const [playEnabled, setPlayEnabled] = useState(false)
  const [pauseEnabled, setPauseEnabled] = useState(false)
  const [stopEnabled, setStopEnabled] = useState(false)
  const [srcEnabled, setSrcEnabled] = useState(false)
  const onClickPlay = useCallback(() => {
    audioContext.play()
  }, [])
  const onClickPause = useCallback(() => {
    audioContext.pause()
  }, [])
  const onClickStop = useCallback(() => {
    audioContext.stop()
  }, [])
  const onClickSrc = useCallback(() => {
    const newIndex = (srcIndex + 1) % SRC_ARR.length
    setSrcIndex(newIndex)
    audioContext.src = SRC_ARR[newIndex]
  }, [srcIndex])

  return (
    <DemoBlock label='Audio Player' flexDirection='column'>
      <Button onClick={onClickPlay} disabled={!playEnabled}>
        play
      </Button>
      <Button onClick={onClickPause} disabled={!pauseEnabled}>
        pause
      </Button>
      <Button onClick={onClickStop} disabled={!stopEnabled}>
        stop
      </Button>
      <Button onClick={onClickSrc} disabled={!srcEnabled}>
        change src
      </Button>
    </DemoBlock>
  )
}
