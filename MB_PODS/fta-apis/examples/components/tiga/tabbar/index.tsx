/**
 * title: 'Tabbar tabbar'
 * componentName: 'Tabbar'
 * des: 'tabbar'
 * previewUrl: 'components/tiga/tabbar'
 * materialType: 'component'
 * package: '@fta/components-tabbar'
 */
import { Input, Textarea, Radio } from '@fta/components'
import { RadioOption } from '@fta/components/types/radio'
import { Button, DemoBlock, Layout } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'

export default () => {
  const context = useThreshContext()

  const [tabListData, setTabListData] = useState('')
  const [tabPageName, setTabPageName] = useState('maincargo')
  const [badgeText, setBadgeText] = useState('99+')
  const [hintText, setHintText] = useState('测试hint')
  const [bubbleText, setBubbleText] = useState('测试bubble')

  const [updateItemTitle, setUpdateItemTitle] = useState('测试title')
  const [updateItemIcon, setUpdateItemIcon] = useState(
    'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/ab1759a0-75b7-49a3-9294-7ba6fe6c69a1.png'
  )
  const [updateItemSelectIcon, setUpdateItemSelectIcon] = useState(
    'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/19370067-bb6f-4b8e-980e-b5a8ad033c05.png'
  )

  const [tempItemTitle, setTempItemTitle] = useState('临时title')
  const [tempItemIcon, setTempItemIcon] = useState(
    'https://imagecdn.ymm56.com/ymmfile/ymm-appm-tabicon/5baccacf-e4dc-439b-a4b4-fbeefcd116af.png'
  )
  const [tempItemSelectIcon, setTempItemSelectIcon] = useState(
    'https://imagecdn.ymm56.com/ymmfile/ymm-appm-tabicon/100d442e-ddd8-429f-b9cd-3beb6c22b178.png'
  )

  const [showCloseBtnValue, setShowCloseBtnValue] = useState('')

  const [radioOptions, setRadioOptions] = useState<RadioOption<string>[]>([
    { label: '不显示', value: '0' },
    { label: '显示', value: '1' },
  ])

  const handleRadioChange = (value: string): void => {
    setShowCloseBtnValue(value)
  }

  return (
    <Layout title='tabbar' qrcode='components/${type}/${name}/index' style={{ flex: 1 }}>
      <Input
        name='tabPageName'
        title='tabPageName: '
        type='text'
        placeholder='输入tabPageName'
        value={tabPageName}
        onInput={(evt) => setTabPageName?.(evt.detail.value)}
      />

      <DemoBlock label='获取tab列表数据' pure>
        <Button
          onClick={() => {
            setTabListData('')
            console.log('will getTabDataList ----')
            Tiga.Tabbar.getTabDataList({
              context: context,
              complete(res) {
                console.log('complete:', res)
              },
              fail(res) {
                setTabListData(res.reason ?? '失败')
                console.log('fail:', res)
              },
              success(res) {
                setTabListData(JSON.stringify(res))

                console.log('success:', res)
              },
            })
          }}>
          获取tabList数据
        </Button>

        <Textarea
          disabled={false}
          autoHeight={true}
          value={tabListData}
          style={{ width: '100%' }}
          maxlength={9999}
          onChange={() => {}}
        />
      </DemoBlock>

      <DemoBlock label='显示badge, 推荐3个字以内，显示不下时显示...' pure>
        <Input
          name='showBadge'
          title='text: '
          type='text'
          placeholder='输入badge内容'
          value={badgeText}
          onInput={(evt) => setBadgeText?.(evt.detail.value)}
        />
        <Button
          onClick={() =>
            Tiga.Tabbar.showTabBarBadge({
              context: context,
              tabPageName: tabPageName,
              text: badgeText,
              complete(res) {
                console.log('showTabBarBadge.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarBadge.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarBadge.success:', res)
              },
            })
          }>
          showBadge
        </Button>
      </DemoBlock>

      <DemoBlock label='移除badge' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.hideTabBarBadge({
              context: context,
              tabPageName: tabPageName,
              complete(res) {
                console.log('hideTabBarBadge.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('hideTabBarBadge.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('hideTabBarBadge.success:', res)
              },
            })
          }>
          hideTabBarBadge
        </Button>
      </DemoBlock>

      <DemoBlock label='显示小红点' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.showTabBarRedDot({
              context: context,
              tabPageName: tabPageName,
              complete(res) {
                console.log('showTabBarRedDot.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarRedDot.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarRedDot.success:', res)
              },
            })
          }>
          showTabBarRedDot
        </Button>
      </DemoBlock>

      <DemoBlock label='移除小红点' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.removeTabBarRedDot({
              context: context,
              tabPageName: tabPageName,
              complete(res) {
                console.log('removeTabBarRedDot.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBarRedDot.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBarRedDot.success:', res)
              },
            })
          }>
          removeTabBarRedDot
        </Button>
      </DemoBlock>

      <DemoBlock label='显示hint提示' pure>
        <Input
          name='showHint'
          title='text: '
          type='text'
          placeholder='输入hint内容'
          value={hintText}
          onInput={(evt) => setHintText?.(evt.detail.value)}
        />

        <Button
          onClick={() =>
            Tiga.Tabbar.showTabBarHint({
              context: context,
              tabPageName: tabPageName,
              text: hintText,
              complete(res) {
                console.log('showTabBarHint.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarHint.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBarHint.success:', res)
              },
            })
          }>
          showTabBarHint
        </Button>
      </DemoBlock>

      <DemoBlock label='移除hint提示' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.removeTabBarHint({
              context: context,
              tabPageName: tabPageName,
              complete(res) {
                console.log('removeTabBarHint.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBarHint.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBarHint.success:', res)
              },
            })
          }>
          removeTabBarHint
        </Button>
      </DemoBlock>

      <DemoBlock label='显示气泡' pure>
        <DemoBlock label='是否显示关闭按钮'>
          <Radio
            type='inline'
            options={radioOptions}
            value={showCloseBtnValue}
            onClick={handleRadioChange}
          />
        </DemoBlock>

        <Input
          name='showBubble'
          title='text: '
          type='text'
          placeholder='输入bubble内容'
          value={bubbleText}
          onInput={(evt) => setBubbleText?.(evt.detail.value)}
        />

        <Button
          onClick={() => {
            let showCloseBtn
            if (showCloseBtnValue) {
              showCloseBtn = showCloseBtnValue == '1' ? true : false
            }
            console.log('select closeBtn: ', showCloseBtn)
            Tiga.Tabbar.showTabBubble({
              context: context,
              tabPageName: tabPageName,
              showCloseBtn: showCloseBtn,
              text: bubbleText,
              complete(res) {
                console.log('showTabBubble.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBubble.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('showTabBubble.success:', res)
              },
            })
          }}>
          showTabBubble
        </Button>
      </DemoBlock>

      <DemoBlock label='移除气泡' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.removeTabBubble({
              context: context,
              tabPageName: tabPageName,
              complete(res) {
                console.log('removeTabBubble.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBubble.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('removeTabBubble.success:', res)
              },
            })
          }>
          removeTabBubble
        </Button>
      </DemoBlock>

      <DemoBlock label='持久更新TabItem内容' pure>
        <Input
          name='updateItemTitle'
          title='itemTitle: '
          type='text'
          placeholder='输入title'
          value={updateItemTitle}
          onInput={(evt) => setUpdateItemTitle?.(evt.detail.value)}
        />
        <Input
          name='updateItemIcon'
          title='未选中icon url: '
          type='text'
          placeholder='输入url'
          value={updateItemIcon}
          onInput={(evt) => setUpdateItemIcon?.(evt.detail.value)}
        />
        <Input
          name='setUpdateItemSelectIcon'
          title='选中icon url: '
          type='text'
          placeholder='输入url'
          value={updateItemSelectIcon}
          onInput={(evt) => setUpdateItemSelectIcon?.(evt.detail.value)}
        />

        <Button
          onClick={() =>
            Tiga.Tabbar.updateTabbarItem({
              context: context,
              tabPageName: tabPageName,
              text: updateItemTitle,
              iconPath: updateItemIcon,
              selectIconPath: updateItemSelectIcon,
              iconAnimate: true,
              complete(res) {
                console.log('updateTabbarItem.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('updateTabbarItem.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('updateTabbarItem.success:', res)
              },
            })
          }>
          updateTabbarItem
        </Button>
      </DemoBlock>

      <DemoBlock label='重置持久更新' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.resetTabBarItem({
              context: context,
              tabPageName: tabPageName,
              immediately: true,
              complete(res) {
                console.log('resetTabBarItem.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('resetTabBarItem.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('resetTabBarItem.success:', res)
              },
            })
          }>
          resetTabBarItem
        </Button>
      </DemoBlock>

      <DemoBlock label='临时更新item内容' pure>
        <Input
          name='tempItemTitle'
          title='tempTitle: '
          type='text'
          placeholder='输入临时title'
          value={tempItemTitle}
          onInput={(evt) => setTempItemTitle?.(evt.detail.value)}
        />
        <Input
          name='tempItemIcon'
          title='未选中icon url: '
          type='text'
          placeholder='输入url'
          value={tempItemIcon}
          onInput={(evt) => setTempItemIcon?.(evt.detail.value)}
        />
        <Input
          name='tempItemSelectIcon'
          title='选中icon url: '
          type='text'
          placeholder='输入url'
          value={tempItemSelectIcon}
          onInput={(evt) => setTempItemSelectIcon?.(evt.detail.value)}
        />

        <Button
          onClick={() =>
            Tiga.Tabbar.updateTempTabBarItem({
              context: context,
              tabPageName: tabPageName,
              text: tempItemTitle,
              iconPath: tempItemIcon,
              selectIconPath: tempItemSelectIcon,
              iconAnimate: true,
              complete(res) {
                console.log('updateTempTabBarItem.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('updateTempTabBarItem.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('updateTempTabBarItem.success:', res)
              },
            })
          }>
          updateTempTabBarItem
        </Button>
      </DemoBlock>

      <DemoBlock label='重置临时更新item' pure>
        <Button
          onClick={() =>
            Tiga.Tabbar.resetTempTabBarItem({
              context: context,
              tabPageName: tabPageName,
              iconAnimate: true,
              complete(res) {
                console.log('resetTempTabBarItem.complete:', res)
              },
              fail(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('resetTempTabBarItem.fail:', res)
              },
              success(res) {
                Taro.showToast({ title: res.reason ?? '' })
                console.log('resetTempTabBarItem.success:', res)
              },
            })
          }>
          resetTempTabBarItem
        </Button>
      </DemoBlock>
    </Layout>
  )
}
