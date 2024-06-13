import Taro from '@tarojs/taro'
import { StatInfo } from './statInfo'
import { sandboxDir, Local_user_dir_scheme } from './fileUserpath.thresh'
import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'

class TigaFileManager implements Taro.FileSystemManager {
  async access(option: Taro.FileSystemManager.AccessOption): Promise<void> {
    console.log('TigaManager: ', option.path)

    if (!option.path || option.path.length <= 0) {
      this.errorHandler(option.fail, option.complete)({ errMsg: 'fail no such file or directory' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.path)

    const params = {
      path: absolutePath,
    }

    TigaBridge.call(option.context, 'app.file.exist', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(option.success, option.complete)({ errMsg: 'ok: file is exist' })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: 'fail no such file or directory' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: 'fail no such file or directory' })
      })
  }

  async mkdir(option: Taro.FileSystemManager.MkdirOption): Promise<void> {
    if (!option.dirPath || option.dirPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'mddir fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.dirPath)

    const params = {
      dirPath: absolutePath,
      recursive: option.recursive,
    }

    TigaBridge.call(option.context, 'app.file.mkdir', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({ errMsg: res?.reason ? res.reason : '创建成功' })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to create dir' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to create dir' })
      })
  }

  async rmdir(option: Taro.FileSystemManager.RmdirOption): Promise<void> {
    if (!option.dirPath || option.dirPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'rm fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.dirPath)

    const params = {
      path: absolutePath,
      isDir: true,
      recursive: option.recursive,
    }

    TigaBridge.call(option.context, 'app.file.removeItem', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'ok: rm success' })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to rm dir' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to rm dir' })
      })
  }

  async unlink(option: Taro.FileSystemManager.UnlinkOption): Promise<void> {
    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'unlink fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)

    const params = {
      path: absolutePath,
      isDir: false,
    }

    TigaBridge.call(option.context, 'app.file.removeItem', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'ok: unlink success' })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to unlink file' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to unlink file' })
      })
  }

  async readdir(option: Taro.FileSystemManager.ReaddirOption): Promise<void> {
    if (!option.dirPath || option.dirPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'readDir fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.dirPath)
    const params = {
      dirPath: absolutePath,
    }

    TigaBridge.call(option.context, 'app.file.list', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok',
            files: res.data ? res.data.files : [],
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to readdir' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to readdir' })
      })
  }

  async writeFile(option: Taro.FileSystemManager.WriteFileOption): Promise<void> {
    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'writeFile fail: Path permission denied, 请传入正确路径' })
      return
    }

    if (!option.data) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'writeFile fail: Path permission denied, 请传入写入数据' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)
    const params = {
      filePath: absolutePath,
      data: option.data,
    }

    TigaBridge.call(option.context, 'app.file.writeFile', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok: writeFile success',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to writeFile' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to writeFile' })
      })
  }

  async appendFile(option: Taro.FileSystemManager.AppendFileOption): Promise<void> {
    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'appendFile fail: Path permission denied, 请传入正确路径' })
      return
    }

    if (!option.data) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'appendFile fail: Path permission denied, 请传入写入数据' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)
    const params = {
      filePath: absolutePath,
      data: option.data,
      append: true,
    }

    TigaBridge.call(option.context, 'app.file.writeFile', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok: appendFile success',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to appendFile' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to appendFile' })
      })
  }

  async readFile(option: Taro.FileSystemManager.ReadFileOption): Promise<void> {
    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'readFile fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)

    const params = {
      filePath: absolutePath,
    }

    TigaBridge.call(option.context, 'app.file.readFile', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok',
            data: res.data ? res.data?.value : '',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to readFile' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to readFile' })
      })
  }

  async copyFile(option: Taro.FileSystemManager.CopyFileOption): Promise<void> {
    if (!option.srcPath || option.srcPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'copy fail: Path permission denied, 请传入正确源路径' })
      return
    }

    if (!option.destPath || option.destPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'copy fail: Path permission denied, 请传入正确目标路径' })
      return
    }

    const absoluteSrcPath = await sandboxDir.decodeToAbsolutePath(option.context, option.srcPath)
    const absoluteDestPath = await sandboxDir.decodeToAbsolutePath(option.context, option.destPath)

    const params = {
      srcPath: absoluteSrcPath,
      destPath: absoluteDestPath,
    }

    TigaBridge.call(option.context, 'app.file.copyFile', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok: copyFile success',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to copyFile' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to copyFile' })
      })
  }

  async rename(option: Taro.FileSystemManager.RenameOption): Promise<void> {
    if (!option.oldPath || option.oldPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'rename fail: Path permission denied, 请传入正确源路径' })
      return
    }

    if (!option.newPath || option.newPath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'rename fail: Path permission denied, 请传入正确目标路径' })
      return
    }

    const absoluteSrcPath = await sandboxDir.decodeToAbsolutePath(option.context, option.oldPath)
    const absoluteDestPath = await sandboxDir.decodeToAbsolutePath(option.context, option.newPath)

    const params = {
      srcPath: absoluteSrcPath,
      destPath: absoluteDestPath,
    }

    TigaBridge.call(option.context, 'app.file.moveItem', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok: rename success',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to rename' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to rename' })
      })
  }

  async getFileInfo(option: Taro.FileSystemManager.getFileInfoOption): Promise<void> {
    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'getFileInfo fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)

    const params = {
      filePath: absolutePath,
    }

    TigaBridge.call(option.context, 'app.file.getFileInfo', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok',
            size: res?.data?.size,
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to getFileInfo' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to getFileInfo' })
      })
  }

  async saveFile(option: Taro.FileSystemManager.SaveFileOption): Promise<void> {
    if (!option.tempFilePath || option.tempFilePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'saveFile fail: Path permission denied, 请传入正确源路径' })
      return
    }

    if (!option.filePath || option.filePath.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'saveFile fail: Path permission denied, filepath cannot empty' })
      return
    }

    const absoluteSrcPath = await sandboxDir.decodeToAbsolutePath(
      option.context,
      option.tempFilePath
    )
    const absoluteDestPath = await sandboxDir.decodeToAbsolutePath(option.context, option.filePath)
    const params = {
      srcPath: absoluteSrcPath,
      destPath: absoluteDestPath,
    }

    TigaBridge.call(option.context, 'app.file.moveItem', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          this.successHandler(
            option.success,
            option.complete
          )({
            errMsg: res?.reason ? res.reason : 'ok: saveFile success',
          })
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to saveFile' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to saveFile' })
      })
  }

  async stat(option: Taro.FileSystemManager.StatOption): Promise<void> {
    if (!option.path || option.path.length <= 0) {
      this.errorHandler(
        option.fail,
        option.complete
      )({ errMsg: 'get stat fail: Path permission denied, 请传入正确路径' })
      return
    }

    const absolutePath = await sandboxDir.decodeToAbsolutePath(option.context, option.path)
    const params = {
      path: absolutePath,
      recursive: option.recursive,
    }

    TigaBridge.call(option.context, 'app.file.getItemStat', params)
      .then((res) => {
        if (res?.code == TigaGeneral.SUCCESS) {
          console.log('111111stat: ', res)
          /**
           * Taro文档
           * 当 recursive 为 false 时，res.stats 是一个 Stats 对象。
           * 当 recursive 为 true 且 path 是一个目录的路径时，res.stats 是一个 Object，key 以 path 为根路径的相对路径，value 是该路径对应的 Stats 对象。
           */
          if (option.recursive) {
            if (res.data?.list) {
              const list: any[] = res.data?.list
              const statsObj: TaroGeneral.IAnyObject = {}
              list.forEach((element) => {
                const path: string = element.path
                if (path) {
                  const statInfo: StatInfo = new StatInfo(element.stat)
                  statsObj[path] = statInfo
                }
              })

              this.successHandler(
                option.success,
                option.complete
              )({
                errMsg: res?.reason ? res.reason : 'ok',
                stats: statsObj,
              })
            }
          } else {
            let stat
            if (res.data?.list) {
              const list: any[] = res.data?.list

              if (list.length > 0) {
                const obj = list[0]
                stat = obj?.stat
              }
            }
            if (stat) {
              const statInfo: StatInfo = new StatInfo(stat)
              this.successHandler(
                option.success,
                option.complete
              )({
                errMsg: res?.reason ? res.reason : 'ok',
                stats: statInfo,
              })
            } else {
              this.successHandler(
                option.success,
                option.complete
              )({
                errMsg: res?.reason ? res.reason : 'ok',
              })
            }
          }
        } else {
          this.errorHandler(
            option.fail,
            option.complete
          )({ errMsg: res?.reason ? res.reason : 'fail to get stat' })
        }
      })
      .catch((error) => {
        this.errorHandler(
          option.fail,
          option.complete
        )({ errMsg: error?.reason ? error.reason : 'fail to get stat' })
      })
  }

  successHandler(success?: (res: any) => void, complete?: (res: any) => void) {
    return function (res: any): void {
      success && success(res)
      complete && complete(res)
    }
  }

  errorHandler(fail?: (res: any) => void, complete?: (res: any) => void) {
    return function (res: any): void {
      fail && fail(res)
      complete && complete(res)
    }
  }

  /**
   * 缓存目录相关，not implement
   */
  getSavedFileList(option?: Taro.FileSystemManager.getSavedFileListOption): void {
    throw new Error('Method not implemented.')
  }

  removeSavedFile(option: Taro.FileSystemManager.RemoveSavedFileOption): void {
    throw new Error('Method not implemented.')
  }

  /**
   * not implement
   */

  accessSync(path: string): void {
    throw new Error('Method not implemented.')
  }

  appendFileSync(
    filePath: string,
    data: string | ArrayBuffer,
    encoding?: keyof Taro.FileSystemManager.Encoding
  ): void {
    throw new Error('Method not implemented.')
  }
  close(option: Taro.FileSystemManager.CloseOption): void {
    throw new Error('Method not implemented.')
  }
  closeSync(option: Taro.FileSystemManager.CloseSyncOption): void {
    throw new Error('Method not implemented.')
  }

  copyFileSync(srcPath: string, destPath: string): void {
    throw new Error('Method not implemented.')
  }
  fstat(option: Taro.FileSystemManager.FstatOption): void {
    throw new Error('Method not implemented.')
  }
  fstatSync(option: Taro.FileSystemManager.FstatSyncOption): Taro.Stats {
    throw new Error('Method not implemented.')
  }
  ftruncate(option: Taro.FileSystemManager.FtruncateOption): void {
    throw new Error('Method not implemented.')
  }
  ftruncateSync(option: Taro.FileSystemManager.FtruncateSyncOption): void {
    throw new Error('Method not implemented.')
  }

  mkdirSync(dirPath: string, recursive?: boolean): void {
    throw new Error('Method not implemented.')
  }
  open(option: Taro.FileSystemManager.OpenOption): void {
    throw new Error('Method not implemented.')
  }
  openSync(option: Taro.FileSystemManager.OpenSyncOption): string {
    throw new Error('Method not implemented.')
  }
  read(option: Taro.FileSystemManager.ReadOption): void {
    throw new Error('Method not implemented.')
  }
  readCompressedFile(
    option: Taro.FileSystemManager.readCompressedFile.Option
  ): Promise<Taro.FileSystemManager.readCompressedFile.Promised> {
    throw new Error('Method not implemented.')
  }
  readCompressedFileSync(
    option: Taro.FileSystemManager.readCompressedFileSync.Option
  ): ArrayBuffer {
    throw new Error('Method not implemented.')
  }

  readdirSync(dirPath: string): string[] {
    throw new Error('Method not implemented.')
  }
  readFileSync(
    filePath: string,
    encoding?: keyof Taro.FileSystemManager.Encoding,
    position?: number,
    length?: number
  ): string | ArrayBuffer {
    throw new Error('Method not implemented.')
  }
  readSync(option: Taro.FileSystemManager.ReadSyncOption): {
    bytesRead: number
    arrayBuffer: ArrayBuffer
  } {
    throw new Error('Method not implemented.')
  }
  readZipEntry(
    option: Taro.FileSystemManager.readZipEntry.Option
  ): Promise<Taro.FileSystemManager.readZipEntry.Promised> {
    throw new Error('Method not implemented.')
  }

  renameSync(oldPath: string, newPath: string): void {
    throw new Error('Method not implemented.')
  }

  rmdirSync(dirPath: string, recursive?: boolean): void {
    throw new Error('Method not implemented.')
  }

  saveFileSync(tempFilePath: string, filePath?: string): string {
    throw new Error('Method not implemented.')
  }

  statSync(path: string, recursive?: boolean): Taro.Stats | TaroGeneral.IAnyObject {
    throw new Error('Method not implemented.')
  }
  truncate(option: Taro.FileSystemManager.TruncateOption): void {
    throw new Error('Method not implemented.')
  }
  truncateSync(option: Taro.FileSystemManager.TruncateSyncOption): void {
    throw new Error('Method not implemented.')
  }

  unlinkSync(filePath: string): void {
    throw new Error('Method not implemented.')
  }
  unzip(option: Taro.FileSystemManager.UnzipOption): void {
    throw new Error('Method not implemented.')
  }
  write(option: Taro.FileSystemManager.WriteOption): void {
    throw new Error('Method not implemented.')
  }

  writeFileSync(
    filePath: string,
    data: string | ArrayBuffer,
    encoding?: keyof Taro.FileSystemManager.Encoding
  ): void {
    throw new Error('Method not implemented.')
  }
  writeSync(option: Taro.FileSystemManager.WriteSyncOption): { bytesWritten: number } {
    throw new Error('Method not implemented.')
  }
}

export const fileManager: TigaFileManager = new TigaFileManager()
