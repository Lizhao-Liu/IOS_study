/**
 * componentName: 'dialog'
 * des: 'dialog 弹窗'
 * previewUrl: 'components/tiga/ui/dialog'
 * materialType: 'component'
 * package: '@fta/components-ui'
 */
import { DemoBlock, Layout, List, ListItem } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React from 'react'
import '../index.scss'

export default () => {
  const context = useThreshContext()
  function showModal1() {
    Taro.showModal({
      content: '单按钮弹窗',
      title: '对话框标题',
      showCancel: false,
      confirmText: '按钮一',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }
  function showModal2() {
    Taro.showModal({
      content: '双按钮弹窗',
      title: '对话框标题',
      showCancel: true,
      cancelText: '取消',
      confirmText: '确定',
      context,
    }).catch((e) => {
      console.log(e)
    })
  }

  function showModalWithLightMask() {
    Taro.showModal({
      content: '双按钮弹窗',
      title: '对话框标题',
      showCancel: true,
      cancelText: '取消',
      confirmText: '确定',
      context,
      mask: 'light'
    }).catch((e) => {
      console.log(e)
    })
  }

  function showModalWithDarkMask() {
    Taro.showModal({
      content: '双按钮弹窗',
      title: '对话框标题',
      showCancel: true,
      cancelText: '取消',
      confirmText: '确定',
      context,
      mask: 'dark'
    }).catch((e) => {
      console.log(e)
    })
  }

  function showInfoDialog1() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
      ],
    })
  }

  function showInfoDialog2() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }

  function showInfoDialog3() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      buttonOrientation: 0,
    })
  }

  function showInfoDialog4() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      buttonOrientation: 1,
    })
  }

  function showInfoDialog5() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
        {
          text: '选项三',
        },
        {
          text: '选项四',
        },
      ],
      buttonOrientation: 1,
    })
  }

  function showInfoDialog6() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
          color: '#32CD32',
        },
        {
          text: '选项二',
          color: '#FFB6C1',
        },
      ],
    })
  }

  function showInfoDialog7() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      showCloseBtn: true,
    })
  }

  function showInfoDialog8() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      canceledOnTouchOutside: true,
    })
  }

  function showInfoDialog9() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      canceledOnTouchOutside: false,
    })
  }
  function showInfoDialog10() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      contentStyle: {
        contentColor: '#DC143C',
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }

  function showInfoDialog11() {
    Tiga.UI.showInfoDialog({
      title: '对话框标题',
      content: `Ei mundi pertinax vis, ea vel tritani ceteros. Et vis stet facete perpetua. Brute ridens torquatos ei vis, sed ei nibh wisi debet, te elitr equidem vocibus cum. Duo accusata ullamcorper et, ex noster aperiri eloquentiam mel.

      Aeque vidisse volutpat usu id, usu impetus neglegentur at. Cu mei vocibus suscipit, eu sea discere veritus, mollis nostrum detracto eum ea. Ea nusquam scaevola forensibus duo, eu altera ancillae aliquando usu. Ut epicuri lobortis assentior duo. Vel id zril tantas perpetua. Eum no vidisse atomorum dissentiet, quo partem ancillae et.

      Delicata honestatis duo ut. Ei duo falli possim fierent. Saperet salutatus cum te, vis numquam partiendo eu. At prima accumsan praesent eos. Eam oratio delectus recusabo cu, eros virtute sapientem est ut, mea eu mazim electram.

      Mel porro paulo commodo in. Mazim aliquam pertinacia cu duo, eum mutat prodesset necessitatibus te. Sed delenit repudiare mnesarchum te. Duo vero mnesarchum no, in movet solet cum. Unum philosophia cum cu.`,
      contentStyle: {
        maxLinesOfContent: 3,
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }

  function showInfoDialog12() {
    Tiga.UI.showInfoDialog({
      content: `Ei mundi pertinax vis, ea vel tritani ceteros. Et vis stet facete perpetua. Brute ridens torquatos ei vis, sed ei nibh wisi debet, te elitr equidem vocibus cum. Duo accusata ullamcorper et, ex noster aperiri eloquentiam mel.

      Aeque vidisse volutpat usu id, usu impetus neglegentur at. Cu mei vocibus suscipit, eu sea discere veritus, mollis nostrum detracto eum ea. Ea nusquam scaevola forensibus duo, eu altera ancillae aliquando usu. Ut epicuri lobortis assentior duo. Vel id zril tantas perpetua. Eum no vidisse atomorum dissentiet, quo partem ancillae et.

      Delicata honestatis duo ut. Ei duo falli possim fierent. Saperet salutatus cum te, vis numquam partiendo eu. At prima accumsan praesent eos. Eam oratio delectus recusabo cu, eros virtute sapientem est ut, mea eu mazim electram.

      Mel porro paulo commodo in. Mazim aliquam pertinacia cu duo, eum mutat prodesset necessitatibus te. Sed delenit repudiare mnesarchum te. Duo vero mnesarchum no, in movet solet cum. Unum philosophia cum cu.`,
      title: '对话框标题',
      contentStyle: {
        maxLinesOfContent: 0,
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }

  function showInfoDialog13() {
    Tiga.UI.showInfoDialog({
      content: `描述文案第一行
第二行
第三行`,
      title: `对话框标题`,
      contentStyle: {
        contentAlignment: 1,
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }
  function showInfoDialog14() {
    Tiga.UI.showInfoDialog({
      content: `描述文案第一行
第二行
第三行`,
      title: `对话框标题`,
      contentStyle: {
        contentAlignment: 0,
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }
  function showInfoDialog15() {
    Tiga.UI.showInfoDialog({
      content: `描述文案第一行
第二行
第三行`,
      title: '对话框标题',
      contentStyle: {
        contentAlignment: 2,
      },
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
    })
  }

  function showStatusDialog1() {
    Tiga.UI.showStatusDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '知道了',
        },
      ],
      statusIcon: 'https://imagecdn.ymm56.com/ymmfile/static/image/trade/success.png',
      buttonOrientation: 0,
      canceledOnTouchOutside: true,
    })
  }

  function showInfoDialogWithDarkMask() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      canceledOnTouchOutside: true,
      mask:'dark'
    })
  }

  function showInfoDialogWithLightMask() {
    Tiga.UI.showInfoDialog({
      content: '描述文案',
      title: '对话框标题',
      context,
      buttons: [
        {
          text: '选项一',
        },
        {
          text: '选项二',
        },
      ],
      canceledOnTouchOutside: true,
      mask:'light'
    })
  }

  return (
    <Layout title='UI' qrcode='components/tiga/ui/dialog/index'>
      <DemoBlock label='基础弹窗' pure>
        <List>
          <ListItem title='单按钮弹窗' arrow='right' onClick={showInfoDialog1} />
          <ListItem title='双按钮弹窗' arrow='right' onClick={showInfoDialog2} />
          <ListItem title='浅色透明蒙层弹窗' arrow='right' onClick={showModalWithLightMask} />
          <ListItem title='深色透明蒙层弹窗' arrow='right' onClick={showModalWithDarkMask} />
        </List>
      </DemoBlock>
      <DemoBlock label='多按钮弹窗' pure>
        <List>
          <ListItem title='双按钮弹窗(横向排列)' arrow='right' onClick={showInfoDialog3} />
          <ListItem title='双按钮弹窗(纵向排列)' arrow='right' onClick={showInfoDialog4} />
          <ListItem title='多按钮弹窗(纵向排列)' arrow='right' onClick={showInfoDialog5} />
          <ListItem title='按钮颜色自定义弹窗' arrow='right' onClick={showInfoDialog6} />
        </List>
      </DemoBlock>
      <DemoBlock label='弹窗隐藏选项' pure>
        <List>
          <ListItem title='带关闭按钮弹窗' arrow='right' onClick={showInfoDialog7} />
          <ListItem title='点击蒙层可关闭弹窗' arrow='right' onClick={showInfoDialog8} />
          <ListItem title='点击蒙层不可关闭弹窗' arrow='right' onClick={showInfoDialog9} />
        </List>
      </DemoBlock>

      <DemoBlock label='自定义弹窗内容样式' pure>
        <List>
          <ListItem title='自定义弹窗内容颜色' arrow='right' onClick={showInfoDialog10} />
          <ListItem title='弹窗内容最大行数为3' arrow='right' onClick={showInfoDialog11} />
          <ListItem title='弹窗内容不限制行数' arrow='right' onClick={showInfoDialog12} />
          <ListItem title='弹窗内容居左对齐' arrow='right' onClick={showInfoDialog13} />
          <ListItem title='弹窗内容居中对齐' arrow='right' onClick={showInfoDialog14} />
          <ListItem title='弹窗内容居右对齐' arrow='right' onClick={showInfoDialog15} />
          <ListItem title='浅色透明蒙层弹窗' arrow='right' onClick={showInfoDialogWithLightMask} />
          <ListItem title='深色透明蒙层弹窗' arrow='right' onClick={showInfoDialogWithDarkMask} />
        </List>
      </DemoBlock>

      <DemoBlock label='状态反馈弹窗' pure>
        <List>
          <ListItem title='自定义状态icon弹窗' arrow='right' onClick={showStatusDialog1} />
        </List>
      </DemoBlock>

      <DemoBlock label='模态弹窗' pure>
        <List>
          <ListItem title='单按钮模态弹窗' arrow='right' onClick={showModal1} />
          <ListItem title='双按钮模态弹窗' arrow='right' onClick={showModal2} />
        </List>
      </DemoBlock>
    </Layout>
  )
}
