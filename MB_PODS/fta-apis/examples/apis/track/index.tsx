import track from '@fta/apis-track'
import { List as AtList, ListItem } from '@fta/components'
import { View } from '@tarojs/components'
import React, { Component } from 'react'
import './index.scss'

export default class Index extends Component {
  render() {
    return (
      <View className='index'>
        <AtList>
          <ListItem
            title='setConfig'
            arrow='right'
            onClick={() => {
              track.setConfig({ appType: 8 })
            }}
          />
          <ListItem
            title='tap'
            arrow='right'
            onClick={() => {
              track.tap('testElementId', { pageName: 'testPage' })
            }}
          />
          <ListItem
            title='view'
            arrow='right'
            onClick={() => {
              track.view('testElementId', { pageName: 'testPage' })
            }}
          />
          <ListItem
            title='pageView'
            arrow='right'
            onClick={() => {
              track.pageView('testPageName')
            }}
          />
          <ListItem
            title='pageViewStayDuration'
            arrow='right'
            onClick={() => {
              track.pageViewStayDuration('testPageName')
            }}
          />
        </AtList>
      </View>
    )
  }
}
// todo: fta-request 插件添加rn支持
