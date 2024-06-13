import 'antd/es/message/style/index'
import React from 'react'
import './color.less'
import { ColorBaseProps, GreyScaleBlockProps } from './types'
import { copyColor } from './utils'

export function GreyScaleBlock(props: GreyScaleBlockProps): JSX.Element {
  return (
    <span
      className='__design-color-box-grey'
      style={{ color: props.textcolor, backgroundColor: props.val }}
      onClick={() => copyColor(props.val, props.title)}>
      <span className='__design-color-box-grey__title'>{props.title}</span>
      <span className='__design-color-box-grey__text'>{props.val}</span>
    </span>
  )
}

export function GreyScaleBlockContainer(props: ColorBaseProps): JSX.Element {
  return <span className='__design-color-box-grey-container'>{props.children}</span>
}
