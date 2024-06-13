/**
 * title: '流程结束'
 * componentName: 'Popup'
 * des: '弹窗管控'
 * previewUrl: 'components/tiga/popup'
 * materialType: 'component'
 * package: '@fta/components-popup'
 */
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import React from 'react'

export default (): JSX.Element => {
  const context = useThreshContext()

  return (
    <Layout title='popup' qrcode='components/${type}/${name}/index'>
      <DemoBlock label='' pure>
        <Button
          onClick={() => {
            Tiga.Popup.finish({
              context: context,
              popupCode: 1234,
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          弹窗结束
        </Button>
      </DemoBlock>
    </Layout>
  )
}
