import { TigaBridge, TigaGeneral, errorHandler, successHandler } from '@fta/tiga-util'
import * as Network from '../request'
import * as Upload from '../types/uploaddown'
import path
const MBUPLOAD_PROGRESS_EVENT = 'MBUploadFileProgressEvent'

export function uploadFiles(option: Upload.UploadTaskOption): Upload.UploadTask {
  const taskId: string = taskuuid()

  let files = option.files

  for (let index = 0; index < files.length; index++) {
    let file = files[index];
    if (!file.fileExtensionName && file.localPath) {
      if (file.localPath.includes(".")) {
        let fileExtension = file.localPath.substring(file.localPath.lastIndexOf(".") + 1)
        if (fileExtension && fileExtension.length > 0 && !fileExtension.includes("/")) {
          file.fileExtensionName = fileExtension.toLowerCase()
          // console.log('上传扩展名: ', file.fileExtensionName)
        }
      }
    }
  }

  const params = {
    taskId: taskId,
    ossServer: option.ossServer,
    processUpdate: 1,
    updateInterval: 500,
    files: option.files,
  }

  let timer: ReturnType<typeof setTimeout> | null = null
  const timeoutPromise = new Promise((_resolve, reject) => {
    if (option.timeout) {
      timer = setTimeout(() => {
        // console.log('上传超时: ', taskId)
        reject({ code: 1001, reason: '上传超时' })
        clearTimeout?.(timer)
        p.abort()
      }, option.timeout)
    }
  })

  const uploadPromise = TigaBridge.call(option.context, 'app.network.uploadFiles', params)
  const p: any = Promise.race([uploadPromise, timeoutPromise])
    .then((resData) => {
      const res: { code?; reason?; data? } = resData || {}
      if (timer) {
        clearTimeout?.(timer)
      }
      removeUploadEventListener()

      if (res.code != 0) {
        const result: TigaGeneral.CallbackResult = {
          code: res.code,
          reason: res.reason,
        }
        return errorHandler(option.fail, option.complete)(result)
      }

      const fileUrls = []
      if (res.data) {
        const ossList: [any] = res.data.ossKeys
        if (ossList && ossList.length > 0) {
          for (let index = 0; index < ossList.length; index++) {
            const element = ossList[index]
            if (element.ossKey) {
              fileUrls.push(element.ossKey)
            }
          }
        }
      }

      const ossList = []
      const absoluteParams = []
      const relativeList = []
      if (fileUrls.length) {
        for (let index = 0; index < fileUrls.length; index++) {
          const urlStr = fileUrls[index]
          const url = new URL(urlStr)
          if (url.pathname) {
            relativeList.push(url.pathname)
            const uploadInfo = option.files[index]
            absoluteParams.push({
              key: url.pathname,
              bizType: uploadInfo.bizType,
            })
          }
        }

        return batchGetFileAbsoluteUrl({
          context: option.context,
          requests: absoluteParams,
        })
          .then((res) => {
            if (res.model) {
              for (let index = 0; index < relativeList.length; index++) {
                const key = relativeList[index]
                const absoluteUrl = res.model[key]
                if (absoluteUrl) {
                  ossList.push({
                    ossKey: key,
                    absoluteUrl: absoluteUrl,
                  })
                }
              }
              const result: Upload.UploadSuccessResult = {
                code: TigaGeneral.SUCCESS,
                reason: '成功',
                ossUrls: fileUrls,
                ossFileList: ossList,
              }
              return successHandler(option.success, option.complete)(result)
            } else {
              const result: TigaGeneral.CallbackResult = {
                code: 4,
                reason: '上传失败，请求到绝对路径为空',
              }
              return errorHandler(option.fail, option.complete)(result)
            }
          })
          .catch((error) => {
            const result: TigaGeneral.CallbackResult = {
              code: 4,
              reason: '上传失败，请求绝对路径失败',
            }
            return errorHandler(option.fail, option.complete)(result)
          })
      } else {
        const result: TigaGeneral.CallbackResult = {
          code: 4,
          reason: '上传失败，没有获取到url',
        }
        return errorHandler(option.fail, option.complete)(result)
      }
    })
    .catch((error) => {
      if (timer) {
        clearTimeout?.(timer)
      }
      removeUploadEventListener()

      const result: TigaGeneral.CallbackResult = {
        code: error.code,
        reason: error.reason,
      }
      return errorHandler(option.fail, option.complete)(result)
    })

  p.abort = () => {
    if (timer) {
      clearTimeout?.(timer)
    }

    if (!taskId) {
      return
    }

    removeUploadEventListener()

    TigaBridge.call(option.context, 'app.network.cancelUpload', { taskId: taskId })
  }

  const events: TigaGeneral.Events = TigaGeneral.getEvents(option.context)
  let progressCallback
  p.onProgressUpdate = (callback) => {
    //  console.log('业务添加进度监听onProgressUpdate: ', callback)
    progressCallback = (listenResult) => {
      //  console.log('MBUploadFileProgressEvent: ', listenResult)

      let data: { taskId; percent }
      if (listenResult.taskId) {
        data = listenResult
      } else if (listenResult.eventData && listenResult.eventData.taskId) {
        data = listenResult.eventData
      }

      if (!data || !data.taskId || data.taskId != taskId) {
        console.log('some is null data: ', data)
        return
      }
      if (callback) {
        // console.log('upload process callback: ', callback)
        callback({ percent: data.percent })
      }
      // else {
      //   console.log('upload process callback null')
      // }
    }

    events.on(MBUPLOAD_PROGRESS_EVENT, progressCallback)
  }

  function removeUploadEventListener() {
    //  console.log('removeUploadEventListener: ', progressCallback)
    if (progressCallback) {
      events.off(MBUPLOAD_PROGRESS_EVENT, progressCallback)
    }
  }

  return p
}

export async function batchGetFileAbsoluteUrl(
  option: Upload.GetAbsoluteOption
): Promise<Upload.GetAbsoluteSuccessResult> {
  const params = { requests: option.requests }
  return Network.request({
    context: option.context,
    // responseType: 'data',
    url: '/ymm-file-app/fileUpload/get/file/batchGetFileAbsoluteUrl',
    data: params,
  })
    .then((res) => {
      // console.log('batchGetFileAbsoluteUrl success:', res)
      const data = res.data
      if (data) {
        const result: Upload.GetAbsoluteSuccessResult = {
          code: TigaGeneral.SUCCESS,
          reason: '成功',
          model: data.model,
        }
        return successHandler(option.success, option.complete)(result)
      } else {
        const result: Upload.GetAbsoluteSuccessResult = {
          code: 1001,
          reason: '获取绝对路径失败, 返回值为空',
        }
        return errorHandler(option.success, option.complete)(result)
      }
    })
    .catch((err) => {
      // console.log('batchGetFileAbsoluteUrl error:', err)
      const result: Upload.GetAbsoluteSuccessResult = {
        code: 1002,
        reason: '获取绝对路径失败',
      }
      return errorHandler(option.success, option.complete)(result)
    })
}

// "a1ca0f7b-51bd-4bf3-a5d5-6a74f6adc1c7"
function taskuuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == 'x' ? r : (r & 0x3) | 0x8
    return v.toString(16)
  })
}
