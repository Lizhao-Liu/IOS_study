import { Platform } from '@thresh/thresh-lib'

function isiOS(): boolean {
  if (Platform.OS == 'ios') {
    return true
  }
  return false
}

function isAndroid(): boolean {
  if (Platform.OS == 'android') {
    return true
  }
  return false
}

export { isiOS, isAndroid }
