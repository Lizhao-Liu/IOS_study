import Tiga from '@fta/tiga'

function parsePageId(options) {
  const pageId = options.query['tiga-page']
  return pageId ? pageId : options.path
}

function parseLocalUrl(options) {
  const url = new URL(`this:///${options.path}`)
  for (let prop in options.query) {
    if (prop == 'tiga-page') {
      continue
    }
    url.searchParams.append(prop, options.query[prop])
  }
  console.log('parseLocalUrl', url.toString())
  return url
}

export function withNavigator(Wrapped) {
  return withNavigatorCLZ(Wrapped)
}

function withNavigatorCLZ(Wrapped) {
  return class Wrapper extends Wrapped {
    componentDidShow(options) {
      super.componentDidShow && super.componentDidShow(options)
      console.log('withNavigator 挂载应用', options)

      Tiga.Navigator.onPageShow(parsePageId(options), parseLocalUrl(options))
    }
  }
}

// function withNavigatorFC(Wrapped) {
//   return class Wrapper extends React.Component {
//     componentDidShow(options) {
//       // console.log('withNavigatorFC', super.componentDidShow ? 'T' : 'F')
//       // super.componentDidShow && super.componentDidShow(options)
//       console.log('withNavigator 挂载应用', options)
//       // test()

//       Tiga.Navigator.onPageShow(parsePageId(options))
//     }

//     render() {
//       return <Wrapped {...this.props} />
//     }
//   }
// }

export function initNavigator() {}
