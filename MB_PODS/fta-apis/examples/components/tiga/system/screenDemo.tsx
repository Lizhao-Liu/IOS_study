import { InputNumber, Toggle } from '@fta/components'
import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React, { useEffect, useState } from 'react'

function ScreenDemoBlock() {
  const context = useThreshContext()
  const [screenBrightnessValue, setScreenBrightnessValue] = useState(0)
  const [keepScreenOn, setKeepScreenOn] = useState(false)
  const [isInitialized, setIsInitialized] = useState(false)

  useEffect(() => {
    const initialize = async (): Promise<void> => {
      await new Promise<void>((resolve) => {
        Taro.getScreenBrightness({ context })
          .then((res: any) => {
            setScreenBrightnessValue(res.value.toFixed(1))
          })
          .catch((e: any) => {
            Taro.showModal({
              context,
              content: e.reason,
              title: '获取屏幕亮度失败',
              showCancel: false,
            })
          })
          .finally(() => {
            resolve()
          })
      })

      setIsInitialized(true)
    }

    initialize()
  }, [])

  const handleSetScreenBrightness = async (value: number): Promise<void> => {
    setScreenBrightnessValue(value)
    Taro.setScreenBrightness({ value, context }).then((res: any) => {
      Taro.showToast({
        title: '亮度设置成功',
        mask: false,
        context,
        duration: 1500,
      }).catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason,
          title: '亮度设置失败',
          showCancel: false,
        })
      })
    })
  }

  const handleSetKeepScreenOn = async (isOn: boolean): Promise<void> => {
    setKeepScreenOn(isOn)
    Taro.setKeepScreenOn({ keepScreenOn: isOn, context }).then((res: any) => {
      Taro.showToast({
        title: isOn ? '已设置为常亮' : '已关闭常亮',
        mask: false,
        context,
        duration: 1500,
      }).catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason,
          title: '设置常亮失败',
          showCancel: false,
        })
      })
    })
  }

  const getPhoneScreenBrightness = async (): Promise<void> => {
    Taro.getScreenBrightness({ context }).then((res: any) => {
      Taro.showModal({
        context,
        content: '亮度: ' + res.value,
        title: '当前屏幕亮度',
        showCancel: false,
      })
    })
  }

  if (!isInitialized) {
    return null // 或者展示一个加载中的状态
  }

  return (
    <>
      <DemoBlock label='设置屏幕亮度 范围 0 ~ 1 (0 最暗, 1 最亮)' justifyContent='space-around'>
        <InputNumber
          type='digit'
          min={0}
          max={1}
          step={0.1}
          value={screenBrightnessValue}
          onChange={handleSetScreenBrightness}
        />
      </DemoBlock>
      <DemoBlock label='获取屏幕亮度' pure>
        <Button onClick={getPhoneScreenBrightness}>获取屏幕亮度</Button>
      </DemoBlock>
      <DemoBlock label='设置屏幕常亮' justifyContent='space-around'>
        <Toggle
          active={keepScreenOn}
          width={144}
          controls={false}
          onChange={handleSetKeepScreenOn}
        />
      </DemoBlock>
    </>
  )
}

export default ScreenDemoBlock
