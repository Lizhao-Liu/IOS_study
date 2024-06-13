import { BundleInfo } from './bundleTypes'

export function getBundleInfo(): BundleInfo {
  return {
    bundleName: globalThis.__bizBundleName || globalThis.MBBundleInfo?.bundleName || 'unknown',
    bundleVersion: globalThis.bundleVersion || globalThis.MBBundleInfo?.bundleVersion || 'unknown',
    bundleType: 'thresh',
  }
}

export { BundleInfo }
