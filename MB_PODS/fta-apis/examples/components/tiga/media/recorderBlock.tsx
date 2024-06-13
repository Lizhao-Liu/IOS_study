import { useThreshContext } from '@fta/hooks'
import { Button, DemoBlock } from '@fta/components/common/display'
import Tiga, { TigaGeneral } from '@fta/tiga'
import Taro, { RecorderManager } from '@tarojs/taro'
import React, { useEffect, useState } from 'react'
import { Input, Textarea, Text, Toggle } from '@fta/components'

let recorderInstance: Taro.RecorderManager

function createRecorderInstance() {
  console.log('生成录音实例++++++++++++++')
  recorderInstance = Taro.getRecorderManager()
  return recorderInstance
}

function RecorderBlock() {
  const context = useThreshContext()

  const [result, setResult] = useState('')
  const [duration, setDuration] = useState(60000)
  const rateMap: { [key: number]: keyof RecorderManager.SampleRate } = {
    8000: 8000,
    11025: 11025,
    12000: 12000,
    16000: 16000,
    22050: 22050,
    24000: 24000,
    32000: 32000,
    44100: 44100,
    48000: 48000,
  }
  const [sampleRate, setSampleRate] = useState(8000)
  const [encodeBitRate, setEncodeBitRate] = useState(48000)
  const channelMap: { [key: number]: keyof RecorderManager.NumberOfChannels } = {
    1: 1,
    2: 2,
  }
  const [numberOfChannels, setNumberOfChannels] = useState(2)
  const formatMap: { [key: string]: keyof RecorderManager.Format } = {
    aac: 'aac',
  }
  const [format, setFormat] = useState('aac')

  return (
    <>
      <DemoBlock label='录音' pure>
        <Input
          className='durationname'
          title='duratio(ms)：'
          placeholder='输入录音时长，默认60000'
          value={duration.toString()}
          onInput={(evt) => setDuration?.(parseInt(evt.detail.value))}
        />

        <Input
          className='samplename'
          title='sampleRate：'
          placeholder='输入采样率，默认8000'
          value={sampleRate.toString()}
          onInput={(evt) => setSampleRate?.(parseInt(evt.detail.value))}
        />

        <Input
          className='encodebite'
          title='encodeBitRate：'
          placeholder='输入码率，默认48000'
          value={encodeBitRate.toString()}
          onInput={(evt) => setEncodeBitRate?.(parseInt(evt.detail.value))}
        />

        <Input
          className='numberOfChannels'
          title='numberOfChannels：'
          placeholder='输入声道数，默认2'
          value={numberOfChannels.toString()}
          onInput={(evt) => setNumberOfChannels?.(parseInt(evt.detail.value))}
        />

        <Input
          className='format'
          title='编码格式：'
          placeholder='输入编码格式，当前只支持aac'
          value={format}
          onInput={(evt) => setFormat?.(evt.detail.value)}
        />

        <Textarea
          title='收到事件：'
          disabled={false}
          autoHeight={true}
          value={result}
          style={{ width: '100%' }}
          maxLength={9999}
          onChange={() => {}}
        />

        <Button
          onClick={() => {
            if (recorderInstance) {
              recorderInstance.stop()
            }

            createRecorderInstance()

            recorderInstance.onStart((res: TaroGeneral.CallbackResult) => {
              console.log('(onStart)录音开始回调: ', res.errMsg)
              setResult('(onStart)录音开始回调：' + JSON.stringify(res))
              Taro.showToast({
                context: context,
                title: '录音开始',
              })
            })
            recorderInstance.onStop((res: Taro.RecorderManager.OnStopCallbackResult) => {
              setResult('(onStop)录音结束：' + JSON.stringify(res))

              Taro.showToast({
                context: context,
                title: '录音结束',
              })
            })
            recorderInstance.onError((res: Taro.RecorderManager.OnErrorCallbackResult) => {
              console.log('录音发生错误: ', res.errMsg)
              setResult('(onError)录音发生错误：' + res.errMsg)
              Taro.showToast({
                context: context,
                title: '(onError)录音发生错误: ' + res.errMsg,
              })
            })

            const rate: keyof RecorderManager.SampleRate = rateMap[sampleRate]
            const channelNum: keyof RecorderManager.NumberOfChannels = channelMap[numberOfChannels]
            const formatID: keyof RecorderManager.Format = formatMap[format]
            recorderInstance.start({
              context: context,
              duration: duration,
              sampleRate: rate,
              numberOfChannels: channelNum,
              format: formatID,
            })
          }}>
          开始录音
        </Button>

        <Button
          onClick={() => {
            if (recorderInstance) {
              recorderInstance.stop()
            }
          }}>
          结束录音
        </Button>
      </DemoBlock>
    </>
  )
}

export default RecorderBlock
