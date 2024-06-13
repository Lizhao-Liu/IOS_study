import { DemoBlock } from '@fta/components/common/display'
import Tiga from '@fta/tiga'
import { Button } from '@tarojs/components'
import React, { useCallback, useState } from 'react'

export default function TextSpeakerBlock() {
  const [speaker] = useState(Tiga.Media.getSpeaker)
  const [token, setToken] = useState<string>()

  const onClickSpeak = useCallback(() => {
    const text = '这是合成语音'
    speaker.speak({text,
      onStart(token: string) {
        console.log("text audioplayer onStart, token: ", token)
      },
      onEnded(token: string) {
        console.log("text audioplayer onEnded, token: ", token)
      },
      onError(token: string, errorMsg?: string) {
        console.log("text audioplayer token: ", token, " onError: ", errorMsg)
      }
    }).then((res) => {
      setToken(res.token)
    })
  }, [])
  const onClickStop = useCallback(() => {
    if (token) {
      speaker.stop({ token })
    }
  }, [token])

  return (
    <DemoBlock label='Text Speaker' flexDirection='column'>
      <Button onClick={onClickSpeak}>speak</Button>
      <Button onClick={onClickStop}>stop</Button>
    </DemoBlock>
  )
}
