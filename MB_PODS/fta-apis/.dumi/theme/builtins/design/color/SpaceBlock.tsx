import 'antd/es/message/style/index'
import React from 'react'
import './color.less'
import { ColorBaseProps, SquareBlockProps } from './types'
import { copyColor } from './utils'

export function SpaceBlock(props: SquareBlockProps): JSX.Element {
  return (
    <span
      className='__design-color-box-space'
      style={{ color: props.textcolor || '#fff', backgroundColor: props.val }}
      onClick={() => copyColor(props.val, props.title)}>
      <span className='__design-color-box-space__title'>{props.title}</span>
      <span className='__design-color-box-space__text'>
        <span>{props.val}</span>
        {props.val1 && (
          <span
            onClick={(e) => {
              e.stopPropagation()
              copyColor(props.val1 as string, props.title)
            }}>
            {props.val1}
          </span>
        )}
      </span>
    </span>
  )
}

export function SpaceBlockContainer(props: ColorBaseProps): JSX.Element {
  return <span className='__design-color-box-space-container'>{props.children}</span>
}
