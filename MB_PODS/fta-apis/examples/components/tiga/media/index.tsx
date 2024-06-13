/**
 * title: 'Media 多媒体'
 * componentName: 'Media'
 * des: '多媒体文件操作'
 * previewUrl: 'components/tiga/media'
 * materialType: 'component'
 * package: '@fta/components-media'
 */
import { Button, DemoBlock, Layout, Row } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import { Image, Text } from '@tarojs/components'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'

import AudioPlayerBlock from './audioPlayerBlock'
import FileTransferBlock from './fileTransferBlock'
import RecorderBlock from './recorderBlock'
import TextSpeakerBlock from './textSpeakerBlock'

export default () => {
  const context = useThreshContext()
  const [chooseImageResults, setChooseImageResults] = useState<Array<any>>([])
  const [chooseImageBase64, setChooseImageBase64] = useState<Array<any>>([])

  const [chooseMediaResults, setChooseMediaResults] = useState<Array<any>>([])
  const [chooseMediaBase64, setChooseMediaBase64] = useState<Array<any>>([])

  const [chooseAndUploadImageResults, setChooseAndUploadImageResults] = useState<Array<any>>([])

  const [imageInfo, setImageInfo] = useState<string>()

  const [processImageResult, setProcessImageResult] = useState({
    base64: '',
    path: '',
    imageInfo: '',
  })

  const [chooseFileResult, setChooseFileResult] = useState<string>()
  const [chooseAudioResult, setChooseAudioResult] = useState<string>()

  const [watermarkImageResults, setWatermarkImageResults] = useState<Array<any>>([])
  const [watermarkImageBase64, setWatermarkImageBase64] = useState<Array<any>>([])

  const listener: Tiga.Media.VoiceRecognizeCallBack = function (res: any) {
    console.log(`第一个语音监听`)
    console.log(res)
  }
  const listener2: Tiga.Media.VoiceRecognizeCallBack = function (res: any) {
    console.log(`第二个语音监听`)
    console.log(res)
  }

  return (
    <Layout className='tiga-media' title='多媒体' qrcode='components/${type}/${name}/index'>
      <AudioPlayerBlock />
      <TextSpeakerBlock />
      <DemoBlock label='Taro API' pure>
        <Row>
          {chooseImageBase64?.map((base64, index) => (
            <Image
              style={{
                margin: 4,
                width: 60,
                height: 60,
              }}
              onClick={() => {
                const urls = chooseImageResults.map((image) => {
                  return image.path
                })
                Taro.previewImage({
                  context: context,
                  urls: urls,
                  current: urls[index],
                  showmenu: true,
                })
              }}
              src={`data:image/png;base64,${base64}`}
            />
          ))}
        </Row>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Taro.chooseImage({
              context: context,
              count: 4,
              sourceType: ['album', 'camera'],
              sizeType: ['compressed'],
              success: async (res) => {
                console.log('chooseImage-success', res)
                setChooseImageResults(res.tempFiles)
                setChooseImageBase64(await getImageBase64(context, res.tempFiles))
              },
              fail: (res) => {
                console.log('chooseImage-fail', res)
              },
            })
          }}>
          chooseImage
        </Button>
        <Row>
          {chooseMediaBase64?.map((base64, index) => (
            <Image
              style={{
                margin: 4,
                width: 60,
                height: 60,
              }}
              onClick={() => {
                const sources = chooseMediaResults.map((image) => {
                  const src: Taro.previewMedia.Sources = {
                    url: image.tempFilePath,
                    type: image.fileType,
                  }
                  if (image.fileType === 'video') {
                    src.poster = image.thumbTempFilePath
                  }
                  return src
                })
                Taro.previewMedia({
                  context: context,
                  sources: sources,
                  current: index,
                  menus: [
                    {
                      id: 'demo_menu1',
                      title: '菜单1',
                      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/d2833870-1d2e-4ae3-97bf-c31f7e1b6dbe.png',
                    },
                    {
                      id: 'demo_menu2',
                      title: '菜单2',
                      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/230b6029-26c5-4f9d-a657-ffebd1e1727e.png',
                    },
                    {
                      id: 'demo_menu3',
                      title: '菜单3',
                      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/d2833870-1d2e-4ae3-97bf-c31f7e1b6dbe.png',
                    },
                    {
                      id: 'demo_menu4',
                      title: '菜单4',
                      icon: 'https://devimage.ymm56.com/ymmfile/ymm-appm-tabicon/230b6029-26c5-4f9d-a657-ffebd1e1727e.png',
                    },
                  ],
                  onMenuClick: (menuId, source) => {
                    const index = sources.findIndex((src) => src.url === source.url)
                    Taro.showToast({
                      context,
                      title: `menuId: ${menuId}, source index: ${index}`,
                    })
                    console.log(
                      'onMenuClick',
                      `menuId: ${menuId}, source: ${JSON.stringify(source)}, index: ${index}`
                    )
                  },
                })
              }}
              src={`data:image/png;base64,${base64}`}
            />
          ))}
        </Row>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Taro.chooseMedia({
              context: context,
              count: 4,
              mediaType: ['mix'],
              sourceType: ['album', 'camera'],
              cameraType: 'custom',
              maxDuration: 20,
              sizeType: ['compressed'],
              success: async (res) => {
                console.log('chooseMedia-success', res)
                setChooseMediaResults(res.tempFiles)
                setChooseMediaBase64(await getMediaBase64(context, res.tempFiles))
              },
              fail: (res) => {
                console.log('chooseMedia-fail', res)
              },
            })
          }}>
          chooseMedia
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Taro.saveImageToPhotosAlbum({
              context: context,
              filePath:
                'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F20181%2F17%2F2018117204137_YttMh.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1690427617&t=953fff94e043d532d667ba8de820a249',
              success: (res) => {
                Taro.showToast({ context: context, title: '保存成功' })
                console.log('saveImageToPhotosAlbum-success', res)
              },
              fail: (res) => {
                Taro.showToast({ context: context, title: '保存失败' })
                console.log('saveImageToPhotosAlbum-fail', res)
              },
            })
          }}>
          saveImageToPhotosAlbum
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            if (!chooseMediaResults || chooseMediaResults.length == 0) {
              Taro.showToast({ context: context, title: '需先使用 “chooseMedia” 选择视频' })
              return
            }

            const videos = chooseMediaResults.filter((media) => {
              return 'video' === media.fileType
            })

            if (!videos || videos.length == 0) {
              Taro.showToast({ context: context, title: '需先使用 “chooseMedia” 选择视频' })
              return
            }

            Taro.saveVideoToPhotosAlbum({
              context: context,
              filePath: videos[0].tempFilePath,
              success: (res) => {
                Taro.showToast({ context: context, title: '保存成功' })
                console.log('saveVideoToPhotosAlbum-success', res)
              },
              fail: (res) => {
                Taro.showToast({ context: context, title: '保存失败' })
                console.log('saveVideoToPhotosAlbum-fail', res)
              },
            })
          }}>
          saveVideoToPhotosAlbum
        </Button>
        <Text style={{ margin: 8 }}>{imageInfo ?? ''}</Text>
        <Row>
          <Button
            style={{ margin: 8 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              Taro.getImageInfo({
                context: context,
                src: chooseImageResults[0].path,
                success: (res) => {
                  console.log('getImageInfo-success', res)
                  setImageInfo(`展示的是 “chooseImage” 结果的第一张图\n${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getImageInfo-fail', res)
                  setImageInfo('')
                },
              })
            }}>
            getImageInfo
          </Button>
          <Button
            style={{ margin: 8 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              Taro.getImageInfo({
                context: context,
                src: chooseImageResults[0].originalFilePath,
                success: (res) => {
                  console.log('getImageInfo-original-success', res)
                  setImageInfo(`展示的是 “chooseImage” 结果的第一张的原图\n${JSON.stringify(res)}`)
                },
                fail: (res) => {
                  console.log('getImageInfo-original-fail', res)
                  setImageInfo('')
                },
              })
            }}>
            getImageInfo-original
          </Button>
        </Row>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Taro.getImageInfo({
              context: context,
              src: 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F20181%2F17%2F2018117204137_YttMh.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1690427617&t=953fff94e043d532d667ba8de820a249',
              success: (res) => {
                console.log('getImageInfo-network-success', res)
                setImageInfo(`网络图片\n${JSON.stringify(res)}`)
              },
              fail: (res) => {
                console.log('getImageInfo-network-fail', res)
                setImageInfo('')
              },
            })
          }}>
          getImageInfo-network
        </Button>
        {processImageResult && processImageResult.base64.length > 0 && (
          <Image
            style={{
              margin: 4,
              width: 60,
              height: 60,
            }}
            onClick={() => {
              if (!processImageResult.path) {
                return
              }
              const urls = [processImageResult.path]
              Taro.previewImage({
                context: context,
                urls: urls,
                showmenu: true,
              })
            }}
            src={`data:image/png;base64,${processImageResult.base64}`}
          />
        )}
        {processImageResult && processImageResult.imageInfo.length > 0 && (
          <Text>{processImageResult.imageInfo}</Text>
        )}

        <Row>
          <Button
            style={{ margin: 3 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              Taro.compressImage({
                context: context,
                src: chooseImageResults[0].path,
                quality: 80,
                compressedWidth: 200,
                success: async (res) => {
                  console.log('compressImage-success', res)
                  setProcessImageResult({
                    base64: (await getSingleImageBase64(context, res.tempFilePath)) ?? '',
                    path: res.tempFilePath ?? '',
                    imageInfo:
                      JSON.stringify(
                        await Taro.getImageInfo({ context: context, src: res.tempFilePath })
                      ) ?? '',
                  })
                },
                fail: (res) => {
                  console.log('compressImage-fail', res)
                },
              })
            }}>
            compressImage
          </Button>
          <Button
            style={{ margin: 3 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              Taro.cropImage({
                context: context,
                src: chooseImageResults[0].path,
                cropScale: '1:1',
                success: async (res) => {
                  console.log('cropImage-success', res)
                  setProcessImageResult({
                    base64: (await getSingleImageBase64(context, res.tempFilePath)) ?? '',
                    path: res.tempFilePath ?? '',
                    imageInfo:
                      JSON.stringify(
                        await Taro.getImageInfo({ context: context, src: res.tempFilePath })
                      ) ?? '',
                  })
                },
                fail: (res) => {
                  console.log('cropImage-fail', res)
                },
              })
            }}>
            cropImage
          </Button>
        </Row>
      </DemoBlock>
      <DemoBlock label='Tiga API' pure>
        <Row>
          {watermarkImageBase64?.map((base64, index) => (
            <Image
              style={{
                margin: 4,
                width: 60,
                height: 60,
              }}
              onClick={() => {
                const urls = watermarkImageResults.map((image) => {
                  return image.tempImagePath
                })
                Taro.previewImage({
                  context: context,
                  urls: urls,
                  current: urls[index],
                  showmenu: true,
                })
              }}
              src={`data:image/png;base64,${base64}`}
            />
          ))}
        </Row>
        <Row>
          <Button
            style={{ margin: 3 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              const sources: Tiga.Media.WatermarkSource[] = chooseImageResults.map((image) => {
                return {
                  imagePath: image.path,
                  markConfigs: [
                    {
                      textMark: '小水印',
                      pos: 'right-bottom',
                    },
                    {
                      textMark: '仅供满帮会员认证',
                      pos: 'tiled',
                    },
                  ],
                }
              })
              Tiga.Media.watermark({
                context: context,
                sources: sources,
                success: async (res) => {
                  console.log('watermark-success', res)
                  setWatermarkImageResults(res.files)
                  setWatermarkImageBase64(await getWatermarkImageBase64(context, res.files))
                },
                fail: (res) => {
                  console.log('watermark-fail', res)
                },
              })
            }}>
            text-watermark
          </Button>
          <Button
            style={{ margin: 3 }}
            onClick={() => {
              if (!chooseImageResults || chooseImageResults.length == 0) {
                Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
                return
              }
              if (!processImageResult.path) {
                Taro.showToast({
                  context: context,
                  title: '需先使用 “compressImage” 压缩一张小的水印图片',
                })
                return
              }
              const sources: Tiga.Media.WatermarkSource[] = chooseImageResults.map((image) => {
                return {
                  imagePath: image.path,
                  markConfigs: [
                    {
                      imageMark: processImageResult.path,
                      pos: 'right-top',
                    },
                    {
                      imageMark: processImageResult.path,
                      pos: 'tiled',
                    },
                  ],
                }
              })
              Tiga.Media.watermark({
                context: context,
                sources: sources,
                success: async (res) => {
                  console.log('watermark-success', res)
                  setWatermarkImageResults(res.files)
                  setWatermarkImageBase64(await getWatermarkImageBase64(context, res.files))
                },
                fail: (res) => {
                  console.log('watermark-fail', res)
                },
              })
            }}>
            image-watermark
          </Button>
        </Row>
        <Button
          style={{ margin: 3 }}
          onClick={() => {
            if (!chooseImageResults || chooseImageResults.length == 0) {
              Taro.showToast({ context: context, title: '需先使用 “chooseImage” 选择图片' })
              return
            }
            const sources: Tiga.Media.LocationWatermarkSource[] = chooseImageResults.map(
              (image) => {
                return {
                  imagePath: image.path,
                }
              }
            )
            Tiga.Media.locationWatermark({
              context: context,
              sources: sources,
              success: async (res) => {
                console.log('locationWatermark-success', res)
                setWatermarkImageResults(res.files)
                setWatermarkImageBase64(await getWatermarkImageBase64(context, res.files))
              },
              fail: (res) => {
                console.log('locationWatermark-fail', res)
              },
            })
          }}>
          location-watermark
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.saveBase64({
              context: context,
              base64: imageBase64,
              type: 'jpg',
              success: (res) => {
                Taro.showToast({ context: context, title: '保存成功' })
                console.log('saveBase64-success', res)
              },
              fail: (res) => {
                Taro.showToast({ context: context, title: '保存失败' })
                console.log('saveBase64-fail', res)
              },
            })
          }}>
          saveBase64
        </Button>
        <Row>
          {chooseAndUploadImageResults?.map((ossUrl, index) => (
            <Image
              style={{
                margin: 4,
                width: 60,
                height: 60,
              }}
              onClick={() => {
                Taro.previewImage({
                  context: context,
                  urls: chooseAndUploadImageResults,
                  current: chooseAndUploadImageResults[index],
                  showmenu: true,
                })
              }}
              src={ossUrl}
            />
          ))}
        </Row>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.chooseAndUploadImage({
              context: context,
              bizType: 'app_resources',
              count: 4,
              sourceType: ['album', 'camera'],
              success: async (res) => {
                console.log('chooseAndUploadImage-success', res)
                setChooseAndUploadImageResults(res.ossUrls)
              },
              fail: (res) => {
                console.log('chooseAndUploadImage-fail', res)
              },
            })
          }}>
          chooseAndUploadImage
        </Button>
        <Text style={{ margin: 8 }}>{chooseAudioResult ?? ''}</Text>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.chooseAudio({
              context: context,
              types: ['mp3', 'ogg', 'm4a'],
              count: 2,
              maxSize: 1000000000,
              success: (res) => {
                console.log('chooseAudio-success', res)
                setChooseAudioResult(`chooseAudio-success\n${JSON.stringify(res)}`)
              },
              fail: (res) => {
                console.log('chooseAudio-fail', res)
                setChooseAudioResult(`chooseAudio-fail：\n${JSON.stringify(res)}`)
              },
            })
          }}>
          chooseAudio
        </Button>
        <Text style={{ margin: 8 }}>{chooseFileResult ?? ''}</Text>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.chooseFile({
              context: context,
              mimeTypes: [],
              uniformTypes: [],
              count: 2,
              maxSize: 5000000000,
              success: async (res) => {
                console.log('chooseFile-success', res)
                setChooseFileResult(`chooseFile-success\n${JSON.stringify(res)}`)
              },
              fail: (res) => {
                console.log('chooseFile-fail', res)
                setChooseFileResult(`chooseFile-fail\n${JSON.stringify(res)}`)
              },
            })
          }}>
          chooseFile
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.startVoiceRecognize({
              context: context,
              callBack: listener,
              maxTime: 30,
              fileName: 'who',
              permissionRequest: true,
              topHint: 'hello',
              rationale: 'hello world',
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          开启语音识别
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.startVoiceRecognize({
              context: context,
              callBack: listener2,
              permissionRequest: true,
              topHint: 'hello',
              rationale: 'hello world',
            })
              .then((res) => {
                console.log(res)
              })
              .catch((err) => {
                console.log(err)
              })
          }}>
          开启语音识别2
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.stopVoiceRecognize({
              context: context,
            })
          }}>
          停止语音识别
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.stopVoiceRecognize({
              context: context,
            })
          }}>
          停止语音识别2
        </Button>
        <Button
          style={{ margin: 8 }}
          onClick={() => {
            Tiga.Media.cancelVoiceRecognize({
              context: context,
            })
          }}>
          取消语音识别
        </Button>
      </DemoBlock>

      <RecorderBlock></RecorderBlock>
      <FileTransferBlock></FileTransferBlock>
    </Layout>
  )
}

async function getSingleImageBase64(context: any, file: string): Promise<string> {
  const res = await Tiga.Media.getImageBase64({
    context: context,
    imagePath: file,
  })
  return Promise.resolve(res.base64)
}

async function getImageBase64(
  context: any,
  files: Taro.chooseImage.ImageFile[]
): Promise<Array<string>> {
  const base64Result = await Promise.all(
    files.map(async (file) => {
      const res = await Tiga.Media.getImageBase64({
        context: context,
        imagePath: file.path,
      })
      return res.base64
    })
  )
  return Promise.resolve(base64Result)
}

async function getMediaBase64(
  context: any,
  files: Taro.chooseMedia.ChooseMedia[]
): Promise<Array<string>> {
  const base64Result = await Promise.all(
    files.map(async (file) => {
      const res = await Tiga.Media.getImageBase64({
        context: context,
        imagePath: file.fileType === 'image' ? file.tempFilePath : file.thumbTempFilePath,
      })
      return res.base64
    })
  )
  return Promise.resolve(base64Result)
}

async function getWatermarkImageBase64(
  context: any,
  files: Tiga.Media.WatermarkResultImageFile[]
): Promise<Array<string>> {
  const base64Result = await Promise.all(
    files.map(async (file) => {
      const res = await Tiga.Media.getImageBase64({
        context: context,
        imagePath: file.tempImagePath,
      })
      return res.base64
    })
  )
  return Promise.resolve(base64Result)
}

const imageBase64 =
  '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'
