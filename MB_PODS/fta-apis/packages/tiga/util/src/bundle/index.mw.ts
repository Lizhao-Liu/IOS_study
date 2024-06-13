import { BundleInfo } from './bundleTypes'

export function getBundleInfo(): BundleInfo {
  const project = window?.App?._currentProject || window?.pjInfo?.project_name || 'unknown'
  const version =
    window?.App?._projectConfig?.[project]?.version || window?.pjInfo?.version || 'unknown'
  return {
    bundleName: project,
    bundleVersion: version,
    bundleType: 'h5',
  }
}

export { BundleInfo }
