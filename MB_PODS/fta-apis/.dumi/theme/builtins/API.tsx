import { useAtomAssets, useIntl, useRouteMeta } from 'dumi'
import type { AtomComponentAsset } from 'dumi-assets-types'
import Table from 'dumi/theme-default/builtins/Table'
import React, { useEffect, useState, type FC } from 'react'

type PropertySchema = NonNullable<AtomComponentAsset['propsConfig']['properties']>[string]

const HANDLERS = {
  // entry method
  toString(prop: PropertySchema): string {
    if (typeof prop.type === 'string' && prop.type in this) {
      // value from TypeMap
      if ('enum' in prop) return this.enum(prop)

      return (this as any)[prop.type](prop)
    } else if (prop.type) {
      // non-parsed type, such as ReactNode
      return this.getValidClassName(prop) || prop.type
    } else if ('const' in prop) {
      // const value
      return `${prop.const}`
    } else if ('oneOf' in prop) {
      // oneOf value
      return this.oneOf(prop)
    }

    // unknown type
    return `unknown`
  },

  // type handlers
  string(prop: PropertySchema) {
    return prop.type
  },
  number(prop: PropertySchema) {
    return prop.type
  },
  boolean(prop: PropertySchema) {
    return prop.type
  },
  any(prop: PropertySchema) {
    return prop.type
  },
  object(prop: Extract<PropertySchema, { type: 'object' }>) {
    let props: string[] = []

    Object.entries(prop.properties || {}).forEach(([key, value]) => {
      // skip nested object type
      props.push(
        `${key}${prop.required?.includes(key) ? '' : '?'}: ${
          value.type === 'object' ? 'object' : this.toString(value)
        }`,
      )
    })

    return props.length ? `{ ${props.join('; ')} }` : '{}'
  },
  array(prop: Extract<PropertySchema, { type: 'array' }>) {
    if (prop.items) {
      const className = this.getValidClassName(prop.items)

      return className ? `${className}[]` : `${this.toString(prop.items)}[]`
    }

    return 'any[]'
  },
  // FIXME: extract real type
  element(prop: any) {
    return `<${prop.componentName} />`
  },
  // FIXME: extract real type
  function({ signature }: any) {
    // handle Function type without signature
    if (!signature) return 'Function'

    const signatures = 'oneOf' in signature ? signature.oneOf : [signature]

    return signatures
      .map(
        (signature: any) =>
          `${signature.isAsync ? 'async ' : ''}(${signature.arguments
            .map((arg: any) => `${arg.key}: ${this.toString(arg)}`)
            .join(', ')}) => ${this.toString(signature.returnType)}`,
      )
      .join(' | ')
  },
  // FIXME: extract real type
  dom(prop: any) {
    return prop.className || 'DOM'
  },

  // special handlers
  enum(prop: PropertySchema) {
    return prop.enum!.map((v) => JSON.stringify(v)).join(' | ')
  },
  oneOf(prop: PropertySchema): string {
    return prop.oneOf!.map((v) => this.getValidClassName(v) || this.toString(v)).join(' | ')
  },

  // utils
  getValidClassName(prop: PropertySchema) {
    return 'className' in prop && typeof prop.className === 'string' && prop.className !== '__type'
      ? prop.className
      : null
  },
}

function getFormattedType(tags?: any, typeString?: string) {
  typeString = typeString?.replace(/import\("([^"]+)"\)\./g, (match) => {
    return ''
  })

  const typeLink = tags?.link?.replace(/\s/g, '')
  const types = typeLink?.split('|')

  console.log("haha1", typeLink)
  if (!types || types.size == 0) {
    return typeString
  }
  const pattern = new RegExp(`\\b(${Array.from(types).join('|')})\\b`, 'gi')
  const replacedString = typeString?.replace(pattern, (match) => {
    const anchor = match
      .toLowerCase()
      .trim()
      .replace(/\s/g, '-')
      .replace(/[^a-z0-9-]/g, '')
    return (
      "<span style='color:#1f5de9;' onclick=\"document.querySelector('[id=" +
      anchor +
      ']\').children[0].click()">' +
      match +
      '</span>'
    )
  })

    /**
   * typeString 实际上是已经解析过的具体的类型定义
   * 比如 { shareScene: string; shareParams?: object }
   * 而不是类的名称（和dumi1的不一致）则不会匹配
   * 为了沿用之前的API表格展示类型名称和link跳转的形式，此处判断是否存在匹配，如果未匹配处理为就使用link的类型名称做展示
   */
  if(replacedString === typeString){ // 如果没有发生替换，则使用备注中link标签关联的类型名称生成超链接

    const anchor = typeLink
    .toLowerCase()
    .trim()
    .replace(/\s/g, '-')
    .replace(/[^a-z0-9-]/g, '')

    return (
      "<span style='color:#1f5de9;' onclick=\"document.querySelector('[id=" +
      anchor +
      ']\').children[0].click()">' +
      typeLink +
      '</span>'
    )
  } else {
    return replacedString
  }
}

const formatType = (type: string) => {
  return type.slice(0, 30) + '...'
}

const APIType: FC<PropertySchema> = (prop) => {
  const [type, setType] = useState(() => HANDLERS.toString(prop))

  useEffect(() => {
    setType(HANDLERS.toString(prop))
  }, [prop])

  return (
    <code style={{ whiteSpace: 'nowrap', textOverflow: 'ellipsis', overflow: 'hidden' }}
      dangerouslySetInnerHTML={{
        __html: `${getFormattedType(prop.tags, type) ?? type}`,
    }}></code>
  )
}

const API: FC<{ id?: string, hideDefault?: boolean }> = (props) => {
  const { frontmatter } = useRouteMeta()
  const { components } = useAtomAssets()
  const id = props.id || frontmatter.atomId
  const intl = useIntl()

  if (!id) throw new Error('`id` properties if required for API component!')

  const definition = components?.[id]
  console.log("haha5", components)
  console.log('props.id: ',  props.id, ' frontmatter.atomId: ', frontmatter.atomId)
  console.log('definition: ',  definition, ' definition.propsConfig.properties: ', definition?.propsConfig.properties)
  const result = parsePropsAndEventsThroughPropsConfig(definition?.propsConfig?.properties)

  return (
    <div className="markdown">
      {/* <h3>Props</h3> */}
      <Table>
        <thead>
          <tr>
            <th>{intl.formatMessage({ id: 'api.component.name' })} </th>
            <th>{intl.formatMessage({ id: 'api.component.description' })}</th>
            <th>{intl.formatMessage({ id: 'api.component.type' })}</th>
            { !props.hideDefault ? (<th>{intl.formatMessage({ id: 'api.component.default' })}</th>) : null}
            <th>版本</th>
          </tr>
        </thead>
        <tbody>
          {definition && definition.propsConfig?.properties ? (
            result.props.map(([name, prop]) => (
              <tr key={name}>
                <td>{name}</td>
                <td dangerouslySetInnerHTML={{ __html: formattedDescription(prop.description).replace(/\n/g, '<br>') }} ></td>
                <td>
                  <APIType {...prop} />
                </td>
                { !props.hideDefault ? (
                  <td>
                  <code>
                    {definition.propsConfig.required?.includes(name)
                      ? intl.formatMessage({ id: 'api.component.required' })
                      : JSON.stringify(prop.default) || '--'}
                  </code>
                </td>
                ) : null}
                <td><code>{prop.tags?.since ?? '--'}</code></td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={ !props.hideDefault ? 4 : 3 }>
                {intl.formatMessage(
                  {
                    id: `api.component.${components ? 'not.found' : 'unavailable'}`,
                  },
                  { id },
                )}
              </td>
            </tr>
          )}
        </tbody>
      </Table>
      {!!result.events.length && (
        <React.Fragment>
          {/* <h3>Events</h3> */}
          <Table>
            <thead>
              <tr>
                <th>{intl.formatMessage({ id: 'api.component.name' })} </th>
                <th>{intl.formatMessage({ id: 'api.component.description' })}</th>
                <th>{intl.formatMessage({ id: 'api.component.type' })}</th>
                <th>{intl.formatMessage({ id: 'api.component.default' })}</th>
                <th>版本</th>
              </tr>
            </thead>
            <tbody>
              {definition && definition.propsConfig?.properties ? (
                result.events.map(([name, prop]) => (
                  <tr key={name}>
                    <td>{name}</td>
                    <td dangerouslySetInnerHTML={{ __html: formattedDescription(prop.description).replace(/\n/g, '<br>') }} ></td>
                    <td>
                      <APIType {...prop} />
                    </td>
                    { !props.hideDefault ? (
                      <td>
                        <code>
                          {definition.propsConfig.required?.includes(name)
                            ? intl.formatMessage({ id: 'api.component.required' })
                            : JSON.stringify(prop.default) || '--'}
                        </code>
                      </td>
                    ) : null}
                    <td>{prop.tags?.since ?? '--'}</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={ !props.hideDefault ? 4 : 3 }>
                    {intl.formatMessage(
                      {
                        id: `api.component.${components ? 'not.found' : 'unavailable'}`,
                      },
                      { id },
                    )}
                  </td>
                </tr>
              )}
            </tbody>
          </Table>
        </React.Fragment>
      )}
    </div>
  )
}

export default API

function formattedDescription(des:string){
  /**
   * 优化展示效果，如果表格存在'--' 就分行展示
   */
  if(!des) return '--';
  // 使用 split 方法根据 '-' 进行分割
  const parts = des.split('-');

  // 将分割后的部分连接起来，每部分加上换行符
  const formattedString = parts.join('<br>');
  return formattedString
}

/**
 * 页面中需要隐藏的属性
 */
const blackPropsList = ['className', 'style', 'customStyle']

function parsePropsAndEventsThroughPropsConfig(properties: Record<string, any> = {}) {
  const props: any[] = []
  const events: any[] = []

  Object.entries(properties).map((ctx) => {
    const [name, prop] = ctx

    // 过滤私有属性
    if (prop.tags?.internal !== undefined || prop.tags?.private !== undefined) return
    // if (/^on[A-Z]/.test(name as string)) {
    //   events.push([name, prop])
    // } else {
    //   if (blackPropsList.includes(name)) return
    //   props.push([name, prop])
    // }
    if (blackPropsList.includes(name)) return
    props.push([name, prop])
  })

  return {
    props,
    events,
  } as const
}
