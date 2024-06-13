/**
 * hideActions: ["CSB"]
 * title: 'LoginPop 统一登录(弹窗版)'
 */

import React, { useState } from 'react'
import { AtButton } from 'taro-ui'
import { View } from '@tarojs/components'
// 导入组件
import LoginPop from '@fta/blocks-web-login-pop'
// 导入样式
import '@fta/blocks-web-login-pop/dist/style.css'

export default () => {
  const showLoginPop = () => {
    /** 显示弹窗 */
    let _loginPopRef = LoginPop.show({
      /** 基础配置参数 */
      loginPayload: {
        /** 来源字段, 必传, 未传默认值未'none' */
        referpage: 'none',
        /** 手机号, 非必传 不传默认是空字符串'' */
        phone: '18510583423',
        /** 用户类型 数字类型 (默认值1) 1: 司机  2: 货主 7: 装卸工 */
        accountType: 1,
        /** 配置参数 数字类型 (默认值1)  1: 只支持注册功能  2: 只支持登录功能 3: 支持注册和登录功能 */
        mode: 3,
        /** 默认值: 0  平台：0 运满满提交，1 货车帮提交，42 装卸拉新，50 浮层H5公共注册/登录  */
        platform: 0,
        /** 默认值时 'com.mb.h5', 默认使用的是h5拉新appId, 有特殊需求请 @张圈圈申请 */
        appId: 'com.mb.h5',
        /** 当前运行环境, 默认'prd'生产环境 */
        env: 'dev',
      },
      /** 功能配置参数 */
      loginConf: {
        /** 日志级别 */
        logLevel: 0,
      },
      /** 样式配置参数 */
      loginLayoutConf: {
        /** 弹窗透明度 */
        modalOpacity: 0.6,
      },
      /** 事件配置参数 */
      loginEventConf: {
        /** 点击遮罩层的回调 */
        onModalClick: (params: any) => {
          console.log('loginEventConf-onModalClick:', params.visible)
        },
      },
      /** 登录成功时的回调 */
      onSuccess: (res: any) => {
        console.log('成功', res)
      },
      /** 登录失败时的回调 */
      onError: (res: any) => {
        console.log('失败', res)
      },
    })

    /** 通过监听事件 */
    _loginPopRef.$on('onModalClick', (e: any) => {
      console.log('$on-onModalClick:', e)
    })
  }

  // 默认展示
  showLoginPop()

  return (
    <View
      style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '500px' }}>
      <AtButton onClick={() => showLoginPop()}>展示登录注册弹窗</AtButton>
    </View>
  )
}
