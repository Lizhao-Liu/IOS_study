import { ConfigProvider } from '@fta/components'
import React, { Component } from 'react'
import './app.scss'
import Tiga from '@fta/tiga'

class App extends Component {
  componentDidShow(options) {
    // called on each page show
    console.log('挂载应用', options)
  }
  onLaunch() {
    // neither called in MW, nor in Thresh
    console.log('启动应用')
  }
  render() {
    console.log('root render')
    return <ConfigProvider>{this.props.children}</ConfigProvider>
  }
}

export function onLaunch(context, params) {
  console.log('onLaunchThresh', context, params)
  Tiga.Navigator.initNavigator()
}

export default Tiga.Navigator.withNavigator(App)

export const MwApp = {
  // 参见微前端项目结构说明 http://techface.amh-group.com/doc/15
  async onLaunch(options) {
    const env = await getEnv()

    if (env === Env.local && !window.MBBridge) {
      loadDevtool(env)
    }
    console.log('MwApp onLaunch!!', options)
    initTrack()
  },
}
