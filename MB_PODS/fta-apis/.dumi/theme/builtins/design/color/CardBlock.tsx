import classNames from 'classnames'
import React, { MouseEvent } from 'react'
import './color.less'
import { CardBlockProps } from './types'
import { copyColor } from './utils'

function CardBlock(props: CardBlockProps): JSX.Element {
  const { val, textcolor, bg, title, subtitle } = props
  return (
    <span
      className='__design-color-box-card'
      style={{ backgroundColor: val, color: textcolor }}
      onClick={() => copyColor(val, title)}>
      <div className='__design-color-box-card-top'>
        <span className='__design-color-box-card__title'>{title}</span>
        <span className={classNames('__design-color-box-card__text')}>{val}</span>
      </div>

      <section
        className='__design-color-box-card-extra-bg'
        style={{ backgroundColor: subtitle }}
        onClick={(e) => copyExtraColor(subtitle, e)}>
        <span style={{ marginLeft: 16, color: val }} className='__design-color-box-card__text'>
          {subtitle}
        </span>
      </section>
    </span>
  )
}

export { CardBlock }

function copyExtraColor(text: string, evt: MouseEvent) {
  evt.stopPropagation()
  copyColor(text)
}
