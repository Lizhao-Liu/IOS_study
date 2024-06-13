import Taro from '@tarojs/taro'
import React from 'react'
import Tiga from '../tiga/tiga/src'

const taro = Taro

const C = () => { }

// ImageChoose
export const Media_TaroChooseImageOption = C as React.FC<Taro.chooseImage.Option>
export const Media_TaroChooseImageSuccessCallbackResult = C as React.FC<Taro.chooseImage.SuccessCallbackResult>
export const Media_TaroChooseImageImageFile = C as React.FC<Taro.chooseImage.ImageFile>
export const Media_ChooseAndUploadImageOption = C as React.FC<Tiga.Media.ChooseAndUploadImageOption>
export const Media_ChooseAndUploadImageSuccessCallbackResult = C as React.FC<Tiga.Media.ChooseAndUploadImageSuccessCallbackResult>

// ImageCompress&crop
export const Media_TaroCompressImageOption = C as React.FC<Taro.compressImage.Option>
export const Media_TaroCompressImageSuccessCallbackResult = C as React.FC<Taro.compressImage.SuccessCallbackResult>
export const Media_TaroCropImageOption = C as React.FC<Taro.cropImage.Option>
export const Media_TaroCropImageSuccessCallbackResult = C as React.FC<Taro.cropImage.SuccessCallbackResult>

// SaveImageToAlbum
export const Media_TaroSaveImageToPhotosAlbumOption = C as React.FC<Taro.saveImageToPhotosAlbum.Option>

// Base64
export const Media_GetImageBase64Option = C as React.FC<Tiga.Media.GetImageBase64Option>
export const Media_GetImageBase64SuccessCallbackResult = C as React.FC<Tiga.Media.GetImageBase64SuccessCallbackResult>
export const Media_SaveImageBase64Option = C as React.FC<Tiga.Media.SaveImageBase64Option>
export const Media_SaveImageBase64SuccessCallbackResult = C as React.FC<Tiga.Media.SaveImageBase64SuccessCallbackResult>

// ImageInfo
export const Media_TaroGetImageInfoOption = C as React.FC<Taro.getImageInfo.Option>
export const Media_TaroGetImageInfoSuccessCallbackResult = C as React.FC<Taro.getImageInfo.SuccessCallbackResult>

// ImageWatermark
export const Media_WatermarkOption = C as React.FC<Tiga.Media.WatermarkOption>
export const Media_WatermarkSource = C as React.FC<Tiga.Media.WatermarkSource>
export const Media_WatermarkConfig = C as React.FC<Tiga.Media.WatermarkConfig>
export const Media_WatermarkSuccessCallbackResult = C as React.FC<Tiga.Media.WatermarkSuccessCallbackResult>
export const Media_WatermarkResultImageFile = C as React.FC<Tiga.Media.WatermarkResultImageFile>
export const Media_LocationWatermarkOption = C as React.FC<Tiga.Media.LocationWatermarkOption>
export const Media_LocationWatermarkSource = C as React.FC<Tiga.Media.LocationWatermarkSource>

// ImagePreview
export const Media_TaroPreviewImageOption = C as React.FC<Taro.previewImage.Option>

// MediaChoose
export const Media_TaroChooseMediaOption = C as React.FC<Taro.chooseMedia.Option>
export const Media_TaroChooseMediaSuccessCallbackResult = C as React.FC<Taro.chooseMedia.SuccessCallbackResult>
export const Media_TaroChooseMediaChooseMedia = C as React.FC<Taro.chooseMedia.ChooseMedia>

// MediaPreview
export const Media_TaroPreviewMediaOption = C as React.FC<Taro.previewMedia.Option>
export const Media_TaroPreviewMediaSources = C as React.FC<Taro.previewMedia.Sources>
export const Media_TaroPreviewMediaMenu = C as React.FC<Taro.previewMedia.Menu>

// SaveVideoToAlbum
export const Media_TaroSaveVideoToPhotosAlbumOption = C as React.FC<Taro.saveVideoToPhotosAlbum.Option>

// AudioChoose
export const Media_ChooseAudioOption = C as React.FC<Tiga.Media.ChooseAudioOption>

// AudioPlayer
export const Media_TaroInnerAudioContext = C as React.FC<Taro.InnerAudioContext>
export const Media_TaroInnerAudioContextOnErrorDetail = C as React.FC<Taro.InnerAudioContext.onErrorDetail>
export const Media_TaroInnerAudioContextOnErrorDetailErrCode = C as React.FC<Taro.InnerAudioContext.onErrorDetailErrCode>

// FileChoose
export const Media_ChooseFileOption = C as React.FC<Tiga.Media.ChooseFileOption>
export const Media_ChooseFileSuccessCallbackResult = C as React.FC<Tiga.Media.ChooseFileSuccessCallbackResult>
export const Media_FileInfo = C as React.FC<Tiga.Media.FileInfo>

// FileTransfer
export const Media_FileTransferOption = C as React.FC<Tiga.Media.FileTransferOption>
export const Media_FileTransferResult = C as React.FC<Tiga.Media.FileTransferResult>

// AudioRecognize
export const Media_RecognizeOption = C as React.FC<Tiga.Media.RecognizeOption>

// TextToSpeech
export const Media_Speaker = C as React.FC<Tiga.Media.Speaker>
export const Media_SpeakerSpeakOption = C as React.FC<Tiga.Media.Speaker.speak.Option>
export const Media_SpeakerSpeakCallbackResult = C as React.FC<Tiga.Media.Speaker.speak.CallbackResult>
export const Media_SpeakerStopOption = C as React.FC<Tiga.Media.Speaker.stop.Option>






