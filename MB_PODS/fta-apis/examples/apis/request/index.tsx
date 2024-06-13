import request from '@fta/apis-request'
import { List as AtList, ListItem } from '@fta/components'
import { View } from '@tarojs/components'
import { showModal } from '@tarojs/taro'
import React, { Component } from 'react'
import './index.scss'

request.extendOptions({
  headers: {
    'Client-Info':
      'bff49c3290a106fbcaa05e306eee4c1f/shipper/7.10.0.0/android/com.xiwei.logistics.consignor',
    Authorization:
      'Basic dV85NjUwMDYwNjU0OTc0NjI4MjM6djNfNjMwM2E4YzkzNDhmNGQxZDhlNTM0ZTgwNDRkMmIwNzQ=',
    YSession: 1637719121410,
  },
})
export default class Index extends Component {
  render() {
    const fetchApi = () => {
      request('https://dev.ymm56.com/searchtruck-app/familiarTruck/searchDriverList', {
        method: 'POST',
      }).then((res: any) => {
        showModal({
          content: JSON.stringify(res, null, 2),
        })
      })
    }
    return (
      <View className='index'>
        <AtList>
          <ListItem title='request' arrow='right' onClick={fetchApi} />
        </AtList>
      </View>
    )
  }
}
// todo: fta-request 插件添加rn支持
