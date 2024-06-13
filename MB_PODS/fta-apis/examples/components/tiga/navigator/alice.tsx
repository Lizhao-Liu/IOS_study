import Tiga from '@fta/tiga'
import { ScrollView } from '@tarojs/components'
import React from 'react'
import { TaroApiView } from './taroPanel'
import { TigaApiView } from './tigaPanel'

// export default class Alice extends React.Component {

//   const pageContext = Tiga.Navigator.create

//   componentDidShow() {
//     console.log('Alice did show')
//     Tiga.Navigator.onPageShow(this.context)
//   }

//   componentDidHide() {
//     console.log('Alice did hide')
//     Tiga.Navigator.onPageHide(this.context)
//   }

//   render() {
//     return (
//       <View>
//         <TaroApiView />
//         <TigaApiView />
//       </View>
//     )
//   }
// }

export default () => {
  return (
    <ScrollView>
      <TaroApiView />
      <TigaApiView />
    </ScrollView>
  )
}
