import { BundleInfo } from './bundleTypes'

export function getBundleInfo(): BundleInfo {
  return {
    bundleName: '__LOGIC_BIZ_NAME__',
    bundleVersion: '__LOGIC_BIZ_VERSION__',
    bundleType: 'global-logic',
  }
}

export { BundleInfo }
