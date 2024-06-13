import { Avatar, Tooltip } from 'antd'

import React, { useEffect, useMemo, useState } from 'react'
import ReactDOM from 'react-dom'
import manifest from '../../../assets/overview.json'
import './Author.less'

const defaultInfo = manifest.contributors['yingkun.li']

interface AuthorProps {
  /**
   * 作者拼音标识
   */
  name: string
  /**
   * 自定义钉钉账号
   */
  dingTalk?: string

  [key: string]: any
}

function getAuthorInfo(key: string): AuthorProps {
  return manifest.contributors[key] || defaultInfo
}

export default function Author(props: AuthorProps): JSX.Element {
  const infos = props.name.split(',').map(getAuthorInfo)
  const [rootEl, setRootEl] = useState<HTMLElement>()

  useEffect(() => {
    requestAnimationFrame(() => {
      const el = document.querySelector(
        '.__dumi-default-layout-author',
      ) as HTMLElement
      setRootEl(el)
    })

    // console.log('滴滴滴', el)
  }, [props.name])

  const authorEl = useMemo(
    () => (
      <span
        style={{
          display: 'inline-block',
          lineHeight: '22px',
          fontSize: 14,
          marginRight: 24,
          marginBottom: 16,
        }}
      >
        <img
          style={{ marginRight: 8, verticalAlign: 'text-top' }}
          width={16}
          height={16}
          src="https://imagecdn.ymm56.com/ymmfile/static/resource/7c2a22c5-6c1d-4743-bea1-a5ba3ca1e0e8.png"
          alt=""
        />
        {infos.map(({ name, dingTalk, avatar, title }, i) => (
          <Tooltip
            key={i}
            overlayStyle={{ width: 200 }}
            overlay={
              <div style={{ height: 92 }}>
                <div style={{ display: 'flex' }}>
                  <Avatar src={avatar} size={36} shape="circle" />
                  <div style={{ marginLeft: 12, lineHeight: '22px' }}>
                    <div style={{ color: '#6f6f6f' }}>{name}</div>
                    <div style={{ color: '#6f6f6f' }}>
                      {title || '前端工程师'}
                    </div>
                  </div>
                </div>
                <a
                  className="__dumi-default-author-contact"
                  href={`dingtalk://dingtalkclient/action/sendmsg?dingtalk_id=${dingTalk}`}
                >
                  联系TA
                </a>
              </div>
            }
          >
            <span
              // title={'钉钉联系' + name}
              style={{ color: '#6f6f6f', cursor: 'pointer' }}
              title='联系TA'
              onClick={() => {window.location.href = `dingtalk://dingtalkclient/action/sendmsg?dingtalk_id=${dingTalk}`}}
            >
              {name}
              {i + 1 !== infos.length ? '、' : ''}
            </span>

          </Tooltip>
        ))}
      </span>
    ),
    [],
  )

  return rootEl ? ReactDOM.createPortal(authorEl, rootEl) : authorEl
}

Author.defaultProps = {
  name: '',
}
