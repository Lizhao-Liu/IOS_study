import { InputNumber, Toggle } from '@fta/components'
import { Button, DemoBlock, Row } from '@fta/components/common/display'
import { Text } from '@tarojs/components'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import Tiga, { TigaGeneral } from '@fta/tiga'
import React, { useCallback, useEffect, useState } from 'react'

function NetworkStatusDemoBlock() {
  const context = useThreshContext()

  const [networkStatusResult, setNetworkStatusResult] = useState('')

  Taro.getNetworkType({ context }).then((res) => {
    setNetworkStatusResult('网络：' + res.networkType)
  })

  const onNetworkStatusChangeCallback = useCallback(
    (res: Taro.onNetworkStatusChange.CallbackResult) => {
      console.log('onNetworkStatusChange', JSON.stringify(res))
      setNetworkStatusResult('网络：' + res.networkType)
    },
    []
  )

  useEffect(() => {
    return () => {
      Taro.offNetworkStatusChange(onNetworkStatusChangeCallback)
    }
  }, [onNetworkStatusChangeCallback])

  return (
    <>
      <DemoBlock label={`Network Status API 当前网络：${networkStatusResult}`} pure>
        <Row style={{ flex: 1, marginBottom: 12 }}>
          <Button
            onClick={() => {
              Taro.onNetworkStatusChange(onNetworkStatusChangeCallback)
            }}>
            注册网路监听
          </Button>
          <Button
            onClick={() => {
              Taro.offNetworkStatusChange(onNetworkStatusChangeCallback)
            }}>
            移除网路监听
          </Button>
        </Row>
      </DemoBlock>
    </>
  )
}

export default NetworkStatusDemoBlock
