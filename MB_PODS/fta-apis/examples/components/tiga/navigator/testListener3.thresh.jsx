import Tiga from '@fta/tiga'
import Thresh from '@thresh/thresh-lib'

function parseLocalUrl(pageName) {
  const localPath = pageName.replace(/-/g, '/')
  return `${Tiga.Navigator.SCHEME_THIS}///${localPath}`
}

export function withNavigator(Wrapped) {
  // return withNavigatorCLZ(Wrapped)
  return Wrapped
}

// function withNavigatorCLZ(Wrapped) {
//   return class Wrapper extends Wrapped {
//     onLaunch(context, params) {
//       super.onLaunch?.(context, params)

//       console.log('withNavigator: onLaunch')

//       initNavigator()
//     }
//   }
// }

let inited = false

export function initNavigator() {
  if (inited) {
    return
  }
  inited = true
  const beforePageDidAppear = Thresh.beforePageDidAppear

  Thresh.beforePageDidAppear = (page, status) => {
    beforePageDidAppear?.(page, status)
    console.log('withNavigator: hooked beforePageDidAppear 3')
    // try {
    //   Tiga.Navigator.onPageShow(page.__context__, parseLocalUrl(page.__pageName__))
    // } catch (err) {
    //   console.log('on error', err)
    // }
    Tiga.Navigator.onPageShow(page.__context__, parseLocalUrl(page.__pageName__))
  }
}
