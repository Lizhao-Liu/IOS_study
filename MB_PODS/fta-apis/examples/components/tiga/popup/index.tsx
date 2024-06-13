/**
 * title: 'Popup 弹窗管控'
 * componentName: 'Popup'
 * des: '弹窗管控'
 * previewUrl: 'components/tiga/popup'
 * materialType: 'component'
 * package: '@fta/components-popup'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Taro from '@tarojs/taro'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='popup' qrcode='components/${type}/${name}/index'>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=finish`,
              context,
            })
          }}>
          弹窗结束
        </Button>
        <DemoBlock label='' pure>
          <Button
            onClick={() => {
              Taro.navigateTo({
                url: `/components/tiga/popup/detail/index?type=tracker`,
                context,
              })
            }}>
            弹窗埋点
          </Button>
        </DemoBlock>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=insert`,
              context,
            })
          }}>
          添加自定义弹窗数据
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=register`,
              context,
            })
          }}>
          注册弹窗信息监听(单个)
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=remove`,
              context,
            })
          }}>
          移除弹窗信息监听
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/detail/index?type=update`,
              context,
            })
          }}>
          更新弹窗实例的请求参数
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/list`,
              context,
            })
          }}>
          示例
        </Button>
      </DemoBlock>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Taro.navigateTo({
              url: `/components/tiga/popup/business`,
              context,
            })
          }}>
          业务测试
        </Button>
      </DemoBlock>
    </Layout>
  )
}
