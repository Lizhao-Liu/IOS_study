import {
  DemoArea,
  DemoBlock,
  Layout as CommonLayout,
  PropsArea,
  Tabs,
} from '@fta/components/common/display'
import { View } from '@tarojs/components'
import React, { useEffect, useState } from 'react'
import './layout.scss'
function Layout(
  props: {
    children: any
    attributes?: { [key: string]: { label: string; options: Array<any> } }
    title: string
    qrcode?: string
    safeArea?: boolean
  } = { attributes: {}, title: '', children: null, safeArea: true }
) {
  const [state, setState] = useState<any>({})

  useEffect(() => {
    const initState: any = {}
    Object.keys(props.attributes || {}).map((key) => {
      initState[key] = 0
    })
    setState({
      ...initState,
    })
  }, [])

  const [childElement, setChildElement] = useState(
    props.children &&
      React.cloneElement(props.children, {
        ...state,
      })
  )

  useEffect(() => {
    setChildElement(
      props.children &&
        React.cloneElement(props.children, {
          ...state,
        })
    )
  }, [state])

  const entries = Object.entries(props.attributes || {})

  return (
    <CommonLayout title={props.title} qrcode={props.qrcode}>
      <View className='container'>
        <DemoArea>{childElement}</DemoArea>
        {/* <View className='bodyStyle'>
          <Text className='titleStyle'></Text>
          {childElement}
        </View> */}
        {entries.length ? (
          <PropsArea>
            {entries.map(([key, value]) => (
              <DemoBlock key={key} label={value.label} flexDirection='column' alignItems='stretch'>
                <Tabs
                  scrollable
                  tabClassName='demo-layout-tab'
                  options={value.options}
                  controls={false}
                  onChange={(i: number, val: any) => {
                    setState({
                      ...state,
                      [key]: i,
                    })
                  }}
                />
              </DemoBlock>
            ))}
          </PropsArea>
        ) : null}
      </View>
    </CommonLayout>
  )
}

export default Layout
