import Taro from '@tarojs/taro'
import { TigaBridge, TigaGeneral } from '@fta/tiga-util'

export const Local_user_dir_scheme = 'mbfile://usr'
const Local_temp_dir_scheme = 'mbtmp://'

if (!Taro.env) {
  Taro.env = {
    USER_DATA_PATH: userpath(),
  }
} else {
  Taro.env['USER_DATA_PATH'] = userpath()
}

console.log('本地用户目录: ', Taro.env.USER_DATA_PATH)

function userpath() {
  // let name = TigaGeneral.getBundleInfo().bundleName
  // if (!name) {
  //   name = ''
  // }
  //return Local_user_dir_scheme + name
  return Local_user_dir_scheme
}

export interface SandboxResult {
  userPath?: string
  tempPath?: string
}

class SandBoxCacheClass {
  private absoluteUserDir: string
  private absoluteTempDir: string

  /**
   * sandboxPath
   */
  public async sandboxUserPath(context: any): Promise<SandboxResult> {
    if (this.absoluteUserDir && this.absoluteTempDir) {
      return new Promise((resolve) => {
        resolve?.({
          userPath: this.absoluteUserDir,
          tempPath: this.absoluteTempDir,
        })
      })
    }

    try {
      if (!this.absoluteUserDir) {
        const result = await TigaBridge.call(context, 'app.file.getSandboxPath', {})
        if (result?.code == TigaGeneral.SUCCESS) {
          this.absoluteUserDir = result?.data?.userPath
          this.absoluteTempDir = result?.data?.tempPath
          return new Promise((resolve) => {
            resolve?.({
              userPath: this.absoluteUserDir,
              tempPath: this.absoluteTempDir,
            })
          })
        } else {
          console.log('get sandbox dir failed!!! reason:', result?.reason)
          return new Promise((resolve) => {
            resolve?.({})
          })
        }
      }
    } catch (error) {
      console.log('get sandbox dir failed!!! error: ', error)
      return new Promise((resolve) => {
        resolve?.({})
      })
    }
  }

  /**
   * decodeToAbsolutePath
   * 根据路径 获取绝对路径，如果传入的不符合Tiga路径规则将直接返回
   */
  public async decodeToAbsolutePath(context: any, path: string): Promise<string> {
    try {
      const sandbox: SandboxResult = await this.sandboxUserPath(context)
      if (!sandbox.userPath) {
        console.log('decode to absolutePath failed!!!')
        return new Promise((resolve) => {
          resolve?.(path)
        })
      }
    } catch (error) {
      console.log('decode to absolutePath failed!!! error: ', error)
      return new Promise((resolve) => {
        resolve?.(path)
      })
    }

    return new Promise((resolve) => {
      if (!path) {
        resolve?.(path)
        return
      }
      if (path.startsWith(Local_user_dir_scheme)) {
        let usrDir = this.absoluteUserDir

        if (usrDir.endsWith('/')) {
          usrDir = usrDir.slice(0, -1)
        }

        const absolutePath = path.replace(Local_user_dir_scheme, usrDir)
        resolve?.(absolutePath)
        return
      } else if (path.startsWith(Local_temp_dir_scheme)) {
        let tmpDir = this.absoluteTempDir

        if (tmpDir.endsWith('/')) {
          tmpDir = tmpDir.slice(0, -1)
        }

        const absolutePath = path.replace(Local_temp_dir_scheme, tmpDir + '/')
        resolve?.(absolutePath)

        return
      }

      resolve?.(path)
    })
  }
}

export const sandboxDir: SandBoxCacheClass = new SandBoxCacheClass()
