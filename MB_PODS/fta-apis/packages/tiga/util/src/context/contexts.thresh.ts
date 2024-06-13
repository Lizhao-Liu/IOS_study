import { getHeadlessServiceContext } from '../event/tigaHeadlessService'

export function getEngineContext(): Promise<any> {
  return getHeadlessServiceContext()
}
