import Taro from '@tarojs/taro'
import { getSandboxPath, sandboxDir } from '@fta/tiga-storage'
import { TigaGeneral, TigaBridge, errorHandler, successHandler } from '@fta/tiga-util'

const MBDownload_PROGRESS_EVENT = 'MBDownloadFileProcessEvent'

interface Func {
  (arg: any): void
}

interface ExtPromise<T> extends Promise<T> {
  onProgressUpdateCb?: Func
  onProgressUpdate?: Func
  abort?: Func

  // 下载状态 0未开始 1下载中 2下载成功 3下载失败 4下载被取消
  downStatus?: number
}

function downloadFile(opts: Taro.downloadFile.Option): Promise<Taro.DownloadTask> {
  const { url, header, filePath, success, fail, complete }: any = opts
  const taskId: string = taskuuid()
  console.log('context: ', opts.context)
  if (!url || url.length <= 0) {
    fail && fail({ errMsg: 'url is null' })
    complete && complete({ errMsg: 'url is null' })
    return
  }
  let localPath = filePath
  let fileName
  if (!localPath) {
    let array = url.split('/')
    let originName: string
    if (array.length > 0) {
      originName = array[array.length - 1]
    }

    fileName = taskId
    if (originName) {
      let list = originName.split('.')
      if (list.length > 0) {
        fileName = fileName + '.' + list[list.length - 1]
      }
    }
  }

  const p: ExtPromise<any> = new Promise(async (resolve, reject) => {
    const progressCallback = (listenResult) => {
      if (p.downStatus == 4) {
        // console.log('download have cancel!!!!!')
        return
      }
      //  console.log('MBUploadFileProgressEvent: ', listenResult)
      const { totalBytesWritten, totalBytesExpectedToWrite } = listenResult
      let progress = (totalBytesWritten / totalBytesExpectedToWrite) * 100
      progress = Number(progress.toFixed(2))
      p.onProgressUpdateCb &&
        p.onProgressUpdateCb({
          progress,
          totalBytesWritten,
          totalBytesExpectedToWrite,
        })
    }

    TigaGeneral.eventCenter.on(MBDownload_PROGRESS_EVENT, progressCallback)
    // console.log('download file 11111111')
    if (!localPath) {
      try {
        const dir = await getSandboxPath({ context: opts.context })
        const tmpdir = dir.tempPath
        if (!tmpdir) {
          const res = { errMsg: 'get sandbox temp path failed' }
          fail && fail(res)
          complete && complete(res)
          reject(res)
          return
        }
        if (tmpdir.endsWith('/')) {
          localPath = tmpdir + fileName
        } else {
          localPath = tmpdir + '/' + fileName
        }
      } catch (error) {
        const res = { errMsg: 'get sandbox path exception' }
        fail && fail(res)
        complete && complete(res)
        reject(res)
        return
      }
    } else {
      try {
        localPath = await sandboxDir.decodeToAbsolutePath(opts.context, localPath)
        if (!localPath) {
          const res = { errMsg: 'decode to sandbox path failed' }
          fail && fail(res)
          complete && complete(res)
          reject(res)
          return
        }
      } catch (error) {
        const res = { errMsg: 'decode to sandbox path exception' }
        fail && fail(res)
        complete && complete(res)
        reject(res)
        return
      }
    }

    const params = {
      taskId: taskId,
      url: url,
      processUpdate: 1,
      updateInterval: 500,
      filePath: localPath,
      limit: 200,
    }
    // console.log('download file 22222222')
    TigaBridge.call(opts.context, 'app.network.downloadFile', params)
      .then((resp) => {
        if (p.downStatus == 4) {
          // console.log('download have cancel!!!!!')
          return
        }
        if (resp?.code != TigaGeneral.SUCCESS || !resp?.data) {
          removeDownloadEventListener()
          const res = {
            errMsg: resp?.reason ? resp?.reason : 'download file fail',
          }
          fail?.(res)
          complete?.(res)
          reject(res)
          return
        }

        let res: Taro.downloadFile.FileSuccessCallbackResult
        if (filePath) {
          res = {
            filePath: filePath,
            tempFilePath: '',
            dataLength: resp.data?.dataLength,
            statusCode: 0,
            errMsg: 'download success',
          }
        } else {
          res = {
            filePath: '',
            tempFilePath: localPath,
            dataLength: resp.data?.dataLength,
            statusCode: 0,
            errMsg: 'download success',
          }
        }

        success?.(res)
        complete?.(res)
        resolve(res)
      })
      .catch((err) => {
        if (p.downStatus == 4) {
          return
        }
        const res = {
          errMsg: 'download file fail',
          err,
        }

        removeDownloadEventListener()
        fail?.(res)
        complete?.(res)
        reject(res)
      })
  })

  p.onProgressUpdate = (cb) => {
    // console.log('download file onProgressUpdate---------')
    if (cb) {
      p.onProgressUpdateCb = cb
    }
  }

  p.abort = () => {
    // console.log('download file abort++++++')
    if (!taskId) {
      return
    }

    p.downStatus = 4

    removeDownloadEventListener()

    TigaBridge.call(opts.context, 'app.network.cancelDownload', { taskId: taskId })
  }

  function removeDownloadEventListener() {
    // console.log('removeDownloadEventListener: ', p.onProgressUpdateCb)
    if (p.onProgressUpdateCb) {
      TigaGeneral.eventCenter.off(MBDownload_PROGRESS_EVENT, p.onProgressUpdateCb)
    }
  }

  return p
}

// "a1ca0f7b-51bd-4bf3-a5d5-6a74f6adc1c7"
function taskuuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == 'x' ? r : (r & 0x3) | 0x8
    return v.toString(16)
  })
}

export { downloadFile }
