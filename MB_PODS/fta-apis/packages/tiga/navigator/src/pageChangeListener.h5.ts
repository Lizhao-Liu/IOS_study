import { getNavigator } from './navigator'

export function onPageShow(context?: any) {
  console.log('onPageShow', context)
  getNavigator(context).onPageShow(context)
}

export function onPageHide(context?: any) {
  console.log('onPageHide', context)
}

export function useNavigator() {
  throw 'Unsupported method: useNavigator()'
}
