import { createFromIconfontCN } from '@ant-design/icons'
import { Avatar, Card, Col, Empty, Row, Tooltip } from 'antd'
import 'antd/es/avatar/style/index'
import 'antd/es/button/style/index'
import 'antd/es/card/style/index'
import 'antd/es/col/style/index'
import 'antd/es/empty/style/index'
import 'antd/es/row/style/index'
import 'antd/es/select/style/index'
import 'antd/es/space/style/index'
import 'antd/es/tag/style/index'
import 'antd/es/tooltip/style/index'
import React, { Fragment, useRef, useState } from 'react'
import mani from '../../../assets/overview.json'
import './Overview.less'

const manifest = mani as unknown as Manifest
const MyIcon = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_2566868_cnrphhubzqf.js', // 在 iconfont.cn 上生成
})

type Arrayable<T> = T | T[]

interface Contributor {
  name: string
  avatar: string
  dingTalk: string
}

interface Component {
  /**
   * 名称
   */
  name: string
  /**
   * 中文名
   */
  remark: string
  /**
   * 跨端
   * @default false
   */
  cross?: boolean
  /**
   * 作者
   * @default null
   */
  author?: null | Arrayable<string>
  /**
   * 组件demo截图
   */
  snapshot?: null | string
  /**
   * 是否是Taro官方组件
   */
  official: boolean
}

type ComponentType =
  | 'basic'
  | 'layout'
  | 'display'
  | 'nav'
  | 'form'
  | 'display'
  | 'tickling'
  | 'pro'
interface Manifest {
  title: string
  subTitle: string
  contributors: Record<string, Contributor>
  components: {
    [key in ComponentType]: {
      name: string
      list: Component[]
    }
  }
  fallback: {
    avatar: string
    snapshot: string
    webpFormat: string
    dingTalk: string
  }
}

function Title(props: { manifest: Manifest }) {
  const { title, subTitle } = props.manifest
  return (
    <>
      <p
        dangerouslySetInnerHTML={{
          __html: subTitle.replace(
            /{{(.*)}}/,
            "<span style='background-color: #ECF3FF; color: #272E3B'>$1</span>"
          ),
        }}></p>
    </>
  )
}

/**
 * 组件信息与查询字符串匹配
 * 匹配组件中英文名、作者姓名，作者邮箱前缀
 */
function hit(comp: Component, ctors: Record<string, Contributor>, query: string) {
  const authors =
    comp.author == null
      ? ''
      : Array.isArray(comp.author)
      ? comp.author.map((a) => ctors[a].name).join('')
      : ctors[comp.author].name

  return (comp.name + comp.remark + comp.author + authors)
    .toLowerCase()
    .includes(query.toLowerCase())
}

/** 搜索过滤 */
function filter(
  list: Array<
    [
      string,
      {
        name: string
        list: Component[]
      }
    ]
  >,
  info: { query: string; fallback: Manifest['fallback']; contributors: Record<string, Contributor> }
) {
  const filteredList = []
  const { query, fallback, contributors } = info

  list.forEach((l) => {
    l[1].list.forEach((v) => {
      if (hit(v, contributors, query)) {
        filteredList.push({ ...v, type: l[0] })
      }
    })
  })
  return filteredList.length ? (
    <div style={{ marginTop: 40, display: 'flex', flexWrap: 'wrap' }}>
      {filteredList.map((item) => (
        <Item key={item.name} data={item} fallback={fallback} type={item.type as ComponentType} />
      ))}
    </div>
  ) : (
    <Empty style={{ marginTop: 100 }} description='暂无数据:)' />
  )
}

function List(props: { manifest: Manifest; query: string }) {
  const { components, fallback, contributors } = props.manifest
  const { query } = props
  const overallList = Object.entries(components)
  return (
    <>
      {query
        ? filter(overallList, { query, fallback, contributors })
        : overallList.map(([key, set]) => (
            <Fragment key={key}>
              <h2>
                <span className='__overview-list-type'>{set.name} </span>
                <span className='__overview-list-number'>{set.list.length}</span>
              </h2>
              <Row>
                {set.list.map((item) => (
                  <Item
                    key={item.name}
                    data={item}
                    fallback={fallback}
                    type={key as ComponentType}
                  />
                ))}
              </Row>
            </Fragment>
          ))}
    </>
  )
}

function getAuthorName(authorList: string[]) {
  return authorList.map((key) => {
    const { name, dingTalk } = manifest.contributors[key] || {}
    return (
      <a
        key={name}
        title={dingTalk && '点击咨询'}
        style={{ color: 'inherit' }}
        href={
          dingTalk
            ? `dingtalk://dingtalkclient/action/sendmsg?dingtalk_id=${dingTalk}`
            : 'javascript:void(0)'
        }>
        {name || key}{' '}
      </a>
    )
  })
}

function getAuthorAvatar(key: string) {
  return manifest.contributors[key]?.avatar || manifest.fallback.avatar
}

function getAuthorDingTalk(key: string) {
  return manifest.contributors[key]?.dingTalk || manifest.fallback.dingTalk
}

function getAuthorAvatarPlaceHolder(key: string) {
  const avatarUrl = getAuthorAvatar(key)
  const avatarEmpty = !avatarUrl || avatarUrl.length == 0
  const name = manifest.contributors[key]?.name
  return avatarEmpty && name && name.length > 1 ? name.substring(0, 1) : ''
}

function Author(props: { name: Component['author']; pending: boolean }) {
  let author = []
  if (!props.pending) {
    author = Array.isArray(props.name) ? props.name : [props.name]
  }
  return (
    <Tooltip title={getAuthorName(author)} placement='top'>
      {author.map((key, i) => (
        <a
          key={i}
          href={`dingtalk://dingtalkclient/action/sendmsg?dingtalk_id=${getAuthorDingTalk(key)}`}
          onClick={(e) => e.stopPropagation()}>
          <Avatar className='__contributor-avatar' alt={key} src={getAuthorAvatar(key)} key={i} />{' '}
        </a>
      ))}
    </Tooltip>
  )
}


/**
 * 大驼峰转连字符小写字符串
 * @param name 大驼峰字符串
 */
function hydrate(name: string) {
  return (name[0] + name.slice(1).replace(/([A-Z])/g, '-$1')).toLowerCase()
}

function Item(props: { data: Component; fallback: Manifest['fallback']; type: ComponentType }) {
  const { name, remark, cross, author, snapshot, support } = props.data
  const { fallback, type } = props
  const pending = !author || !author.length
  return (
    <Col lg={6} xl={5} xxl={5} className='__overview'>
      <a href={`/tiga/${hydrate(name)}/intro`} title={`${hydrate(name)}`}>
        <Card
          style={{
            borderRadius: 4,
            border: 'none',
          }}
          hoverable
          size='small'
          headStyle={{
            border: '1px solid #E0E0E0',
            borderBottom: 'none',
          }}
          title={
            <section>
              <div className='__overview-item-title'>{`${name} ${remark} ${
                pending ? '(待认领)' : ''
              }`}</div>
              <div className='__overview-item-support'>{support.sort().join('/')}</div>
            </section>
          }
          extra={<Author pending={pending} name={author} />}
          bodyStyle={{
            textAlign: 'center',
            maxHeight: 200,
            minHeight: 200,
            display: 'flex',
            alignItems: 'center',
            overflow: 'hidden',
            justifyContent: 'center',
            border: '1px solid #E0E0E0',
          }}
          actions={[]}>
          <img
            src={
              (snapshot || fallback.snapshot) +
              (!snapshot || snapshot?.endsWith('svg') ? '' : fallback.webpFormat)
            }
            loading='lazy'
            style={{ maxWidth: '100%', maxHeight: '100%', verticalAlign: 'middle' }}
            alt={remark}
          />
        </Card>
      </a>
    </Col>
  )
}

/** 搜索框 */
function InputSearch(props: { onSearch?: (query: string) => void }) {
  const ref = useRef<HTMLInputElement>()
  const onSearch = () => {
    const value = ref.current.value
    props.onSearch?.(value)
  }
  return (
    <section className='__overview-search'>
      <input
        autoFocus
        ref={ref}
        type='text'
        placeholder='搜索 Tiga 模块'
        className='__overview-search-input'
        onKeyPress={(e) => {
          e.key === 'Enter' && onSearch()
        }}
        onChange={(e) => e.target.value.length || onSearch()}
      />
      <i className='__overview-search-icon' onClick={onSearch}></i>
    </section>
  )
}

function Overview() {
  const [query, setQuery] = useState<string>('')
  return (
    <>
      <Title manifest={manifest as unknown as Manifest} />
      <InputSearch onSearch={setQuery} />
      <List manifest={manifest as unknown as Manifest} query={query} />
    </>
  )
}

export default Overview
