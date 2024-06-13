import { TigaGeneral } from '@fta/tiga-util'

export function getPackageName() {
  return TigaGeneral.getBundleInfo().bundleName
}
