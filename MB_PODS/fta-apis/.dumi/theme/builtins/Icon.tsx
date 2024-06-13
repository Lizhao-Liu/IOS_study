import { message } from 'antd'
import classNames from 'classnames'
import React, { useState } from 'react'
import { copyTextAsync } from './design/color/utils'
import './Icon.less'

enum IconType {
  outlined = 0,
  filled = 1,
}

const iconList = [
  {
    title: '基础类',
    list: [
      //
      'Left',
      'Right',
      'Down',
      'Up',
      'Check',
      'Close',
      'More',
      //
      'CheckCircle',
      'CloseCircle',
      //
      'MinusCircle',
      'Menu',
      'Rollback',
      'Redo',
      'Clock',
      'Exclamation',
      'PlusCircle',
      // 新增1
      'LeftBorder',
      'RightBorder',
      'UpBorder',
      'DownBorder',
      'MoreBorder',
      'Question',
      'Info',
      'Transform',
      'Arrive',
      'Top',
      'Plus',
      'Minus',
      'ReplaceBorder',
    ],
  },
  {
    title: '操作类',
    list: [
      'Like',
      'Dislike',
      'Edit',
      'Form',
      'Delete',
      'Setting',
      'Search',
      //
      'Send',
      'Star',
      'Heart',
      'Classify',
      'Message',
      'Evaluate',
      'Mail',
      //
      'Calendar',
      'Progress',
      'Rule',
      'Study',
      'Seal',
      'Eye',
      'Share',
      //
      'History',
      // 新增
      'HomePage',
      'Service',
      'Screening',
    ],
  },
  {
    title: '音频图像',
    list: [
      'Bell',
      'Horn',
      'Camera',
      'Image',
      'Phone',
      'Callrecord',
      'Audio',
      //
      'CustomerService',
      'Wechat',
    ],
  },
  {
    title: '运输类',
    list: ['CarDeliver', 'CarTransport', 'CarTruck', 'GoodsDistribute', 'RouteNavigate', 'RouteLocate'],
  },
  {
    title: '交易类',
    list: [
      'Gift',
      'Coupon',
      'RedPacket',
      'GoldCoin',
      'Wallet',
      'Bankcard',
      // 新增1
      'Insure',
    ],
  },
  {
    title: '系统设备',
    list: ['Voice', 'Keyboard'],
  },
  {
    title: '人群身份',
    list: ['UserSingle'],
  },
]

export default function IconDemo() {
  const [type, toggleType] = useState<IconType>(0)
  return (
    <section className="md-icon markdown">
      {/* <h3 className='md-icon-title'>图标</h3> */}
      <Tabs
        options={[
          {
            label: '线性风格',
            value: IconType.outlined,
          },
          {
            label: '填充风格',
            value: IconType.filled,
          },
        ]}
        onChange={toggleType}
      />
      {iconList.map(({ title, list }, i) => (
        <IconBlock type={type} title={title} list={list} key={title} onDoubleClick={() => toggleType((v) => 1 - v)} />
      ))}
    </section>
  )
}

interface TabsProps<V = any> {
  options: Array<{
    label: string
    value: V
  }>
  onChange: (value: V, index: number) => any
}

function Tabs(props: TabsProps) {
  const { options, onChange } = props
  const [active, toggle] = useState(0)
  return (
    <div className="md-icon-tabs">
      {options.map((v, i) => (
        <div
          className={classNames('md-icon-tab', active === i && 'md-icon-tab--active')}
          key={i}
          onClick={(e) => {
            if (e.detail === 1) {
              toggle(i)
              onChange!(v.value, i)
            }
          }}
        >
          {v.label}
        </div>
      ))}
    </div>
  )
}

interface IconBlockProps {
  title: string
  list: string[]
  type: IconType
  onDoubleClick: () => any
}

function IconBlock(props: IconBlockProps) {
  return (
    <div>
      <h4>{props.title}</h4>
      <section className="md-icon-block">
        {props.list.map((value) => (
          <Icon type={props.type} value={value} onDoubleClick={props.onDoubleClick} />
        ))}
      </section>
    </div>
  )
}

function Icon(props: { value: string; type: IconType; onDoubleClick: () => any }) {
  const suffix = props.type === IconType.filled ? 'Filled' : 'Outlined'
  const iconVal = `${props.value}${suffix}`
  const copy = () => {
    copyTextAsync(`<Icon value='${iconVal}' />`).then(() => {
      message.success('图标代码拷贝成功')
    })
  }
  return (
    <div className="md-icon-demo" onClick={copy} onDoubleClick={props.onDoubleClick} data-icon={iconVal}>
      <i className={`fta-icon md-icon-self fta-icon-${iconVal}`}></i>
      <span className="md-icon-name">{iconVal}</span>
    </div>
  )
}
