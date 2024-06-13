import { Textarea } from '@fta/components'
import { Button, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { Label, ScrollView, View } from '@tarojs/components'
import { getCurrentInstance } from '@tarojs/taro'
import React, { useState } from 'react'

function getInstance(): string {
  const ins = getCurrentInstance()
  return ins.router?.params['type'] ?? ''
}

const finishParams = [
  {
    title: '弹窗 code',
    type: 'number',
    param: 'popupCode',
    placeholder: 0,
  },
]

let finishRequestParams: Tiga.Popup.FinishProps = { context: null, popupCode: 0 }

const insertParams = [
  {
    title: '弹窗 interfaceName',
    type: 'string',
    param: 'interfaceName',
    placeholder: '',
  },
  {
    title: '弹窗数据， jsonString',
    type: 'string',
    param: 'data',
    placeholder: '',
  },
  {
    title: '支持展示的页面',
    type: 'string',
    param: 'pageInfoList',
    placeholder: '',
  },
  {
    title: '超时时长',
    type: 'number',
    param: 'availableSeconds',
    placeholder: 300,
  },
]

let insertRequestParams: Tiga.Popup.InsertProps = {
  interfaceName: '',
  data: '',
  pageInfoList: [],
  availableSeconds: 3000,
  show: (res: Tiga.Popup.ShowCallBack) => {
    console.log('执行弹窗展示: ' + res.popupCode + res.data)
  },
}

const trackerParams = [
  {
    title: '弹窗 code',
    type: 'number',
    param: 'popupCode',
    placeholder: 0,
  },
  {
    title: '埋点类型',
    type: 'number',
    param: 'type',
    placeholder: 0,
  },
  {
    title: '埋点参数',
    type: 'object',
    param: 'otherParams',
    placeholder: {},
  },
]

const trackerRequestParams: Tiga.Popup.TrackProps = {
  type: 0,
  popupCode: 0,
}

const registerParams = [
  {
    title: '弹窗 interfaceName',
    type: 'string',
    param: 'interfaceName',
    placeholder: '',
  },
  {
    title: '请求参数',
    type: 'string',
    param: 'requestParams',
    placeholder: {},
  },
  {
    title: '支持的展示的页面',
    type: 'string',
    param: 'pageList',
    placeholder: [],
  },
]

const registerRequestParams: Tiga.Popup.RegisterProps = {
  interfaceName: '',
}

const removeParams = [
  {
    title: '唯一标识',
    type: 'string',
    param: 'dialogId',
    placeholder: '',
  },
  {
    title: '约定的页面',
    type: 'string',
    param: 'pageList',
    placeholder: '',
  },
]

const removeRequestParams: Tiga.Popup.RemoveProps = {
  dialogId: '',
  pageList: [],
}
const updateParams = [
  {
    title: '唯一标识',
    type: 'string',
    param: 'dialogId',
    placeholder: '',
  },
  {
    title: '约定的页面',
    type: 'string',
    param: 'page',
    placeholder: '',
  },
  {
    title: '请求参数',
    type: 'string',
    param: 'requestParams',
    placeholder: '',
  },
]

const updateRequestParams: Tiga.Popup.UpdateProps = {
  dialogId: '',
  requestParams: {},
  page: '',
}

function InputItem(props: {
  title: any
  type: any
  param: any
  placeholder: any
  valueChanged: any
}) {
  const { title, type, param, placeholder, valueChanged } = props

  if (type === 'number') {
    const [num, setNum] = useState(placeholder)

    return (
      <View style='flex-direction:column;' className='item-view'>
        <View style='flex-direction:row;'>
          <Label style='flex-direction:row;' className='item-title'>
            {' '}
            描述: {title}
          </Label>
          <Label style='flex-direction:row;left:10' className='item-type'>
            类型: {type}
          </Label>
          {/* <Label className='item-type'>参数定义: {param}</Label> */}
        </View>
        <Textarea
          value={num.toString()}
          disabled={false}
          count={false}
          height='20'
          onChange={(txt) => {
            setNum(Number(txt))
            valueChanged({ param: param, value: num })
          }}
          autoHeight
        />
      </View>
    )
  } else if (type === 'string') {
    const [str, setStr] = useState(placeholder)

    return (
      <View style='flex-direction:column;' className='item-view'>
        <View style='flex-direction:row;'>
          <Label style='flex-direction:row;' className='item-title'>
            {' '}
            描述: {title}
          </Label>
          <Label style='flex-direction:row;left:10' className='item-type'>
            类型: {type}
          </Label>
          {/* <Label className='item-type'>参数定义: {param}</Label> */}
        </View>
        <Textarea
          value={str}
          disabled={false}
          count={false}
          height='20'
          onChange={(txt) => {
            setStr(txt)
            valueChanged({ param: param, value: str })
          }}
          autoHeight
        />
      </View>
    )
  } else if (type === 'list') {
    const [list, setList] = useState(placeholder)

    return (
      <View style='flex-direction:column;' className='item-view'>
        <View style='flex-direction:row;'>
          <Label style='flex-direction:row;' className='item-title'>
            {' '}
            描述: {title}
          </Label>
          <Label style='flex-direction:row;left:10' className='item-type'>
            类型: {type}
          </Label>
          {/* <Label className='item-type'>参数定义: {param}</Label> */}
        </View>
        <Textarea
          value={JSON.stringify(list)}
          disabled={false}
          count={false}
          height='20'
          onChange={(txt) => {
            setList(JSON.parse(txt))
            valueChanged({ param: param, value: list })
          }}
          autoHeight
        />
      </View>
    )
  } else if (type === 'object') {
    const [obj, setObj] = useState(placeholder)

    return (
      <View style='flex-direction:column;' className='item-view'>
        <View style='flex-direction:row;'>
          <Label style='flex-direction:row;' className='item-title'>
            {' '}
            描述: {title}
          </Label>
          <Label style='flex-direction:row;left:10' className='item-type'>
            类型: {type}
          </Label>
          {/* <Label className='item-type'>参数定义: {param}</Label> */}
        </View>
        <Textarea
          style={{ padding: 10 }}
          value={JSON.stringify(obj)}
          disabled={false}
          count={false}
          height='20'
          onChange={(txt) => {
            setObj(JSON.parse(txt))
            valueChanged({ param: param, value: obj })
          }}
          autoHeight
        />
      </View>
    )
  } else {
    return <View></View>
  }
}
function ListView(props: { contents: any; changed: any }) {
  const { contents, changed } = props
  function renderList() {
    return contents.map(
      (item: { title: any; type: any; placeholder: any; param: any }, index: any) => (
        <InputItem
          // className='list-item'
          title={item.title}
          type={item.type}
          placeholder={item.placeholder}
          param={item.param}
          valueChanged={changed}></InputItem>
      )
    )
  }

  return (
    <ScrollView style={{ padding: 10 }} className='props-list'>
      {renderList()}
    </ScrollView>
  )
}
export default (): JSX.Element => {
  const [res, setRes] = useState('')
  let listData: any
  if (getInstance() === 'finish') {
    listData = finishParams
  } else if (getInstance() === 'insert') {
    listData = insertParams
  } else if (getInstance() === 'tracker') {
    listData = trackerParams
  } else if (getInstance() === 'register') {
    listData = registerParams
  } else if (getInstance() === 'remove') {
    listData = removeParams
  } else if (getInstance() === 'update') {
    listData = updateParams
  }
  const context = useThreshContext()
  return (
    <Layout
      title={getInstance()}
      qrcode='components/${type}/${name}/detail/index'
      style={{ flex: 1 }}>
      <ListView contents={listData} changed={onchange}></ListView>
      <Button
        style={{ top: 10, background: 'blue' }}
        onClick={() => {
          onAction({ type: getInstance(), context })
            .then((res) => {
              console.log('成功' + JSON.stringify(res))
              setRes(JSON.stringify(res))
            })
            .catch((err) => {
              setRes(JSON.stringify(err))
              console.log('失败' + JSON.stringify(err))
            })
        }}>
        确定
      </Button>
      <CreateContent res={res}></CreateContent>
    </Layout>
  )
}

function CreateContent(props: { res: any }): JSX.Element {
  const { res } = props
  return (
    <View style={{ padding: 20 }}>
      <Textarea value={res} disabled={true} count={false} onChange={(txt) => {}} autoHeight />
    </View>
  )
}

function onchange({ param, value }: { param: string; value: any }) {
  console.log('参数变了' + param + value)

  if (getInstance() === 'finish') {
    if (param === 'popupCode') {
      finishRequestParams.popupCode = value
    }
  } else if (getInstance() === 'insert') {
    if (param === 'interfaceName') {
      insertRequestParams.interfaceName = value
    } else if (param === 'data') {
      insertRequestParams.data = value
    } else if (param === 'pageInfoList') {
      insertRequestParams.pageInfoList = JSON.parse(value)
    } else if (param === 'availableSeconds') {
      insertRequestParams.availableSeconds = value
    }
  } else if (getInstance() === 'tracker') {
    if (param === 'type') {
      trackerRequestParams.type = value
    } else if (param === 'popupCode') {
      trackerRequestParams.popupCode = value
    } else if (param === 'otherParams') {
      trackerRequestParams.otherParams = value
    }
  } else if (getInstance() === 'register') {
    if (param === 'interfaceName') {
      registerRequestParams.interfaceName = value
    } else if (param === 'requestParams') {
      registerRequestParams.requestParams = JSON.parse(value)
    } else if (param === 'pageList') {
      registerRequestParams.pageList = JSON.parse(value)
    }
  } else if (getInstance() === 'remove') {
    if (param === 'dialogId') {
      removeRequestParams.dialogId = value
    } else if (param === 'pageList') {
      removeRequestParams.pageList = JSON.parse(value)
    }
  } else if (getInstance() === 'update') {
    if (param === 'dialogId') {
      updateRequestParams.dialogId = value
    } else if (param === 'requestParams') {
      updateRequestParams.requestParams = JSON.parse(value)
    } else if (param === 'page') {
      updateRequestParams.page = value
    }
  }
}

async function onAction({ type, context }: { type: string; context: any }): Promise<any> {
  console.log('触发逻辑: ' + type + '  ' + JSON.stringify(finishRequestParams))
  if (type === 'finish') {
    finishRequestParams.context = context
    return Tiga.Popup.finish(finishRequestParams)
  } else if (type === 'insert') {
    insertRequestParams.context = context
    return Tiga.Popup.insertData(insertRequestParams)
  } else if (type === 'tracker') {
    trackerRequestParams.context = context
    return Tiga.Popup.track(trackerRequestParams)
  } else if (type === 'register') {
    registerRequestParams.context = context
    return Tiga.Popup.registerDialogMonitor(registerRequestParams)
  } else if (type === 'remove') {
    removeRequestParams.context = context
    return Tiga.Popup.removeDialogMonitor(removeRequestParams)
  } else if (type === 'update') {
    updateRequestParams.context = context
    return Tiga.Popup.updateDialogRequestParams(updateRequestParams)
  }
}
