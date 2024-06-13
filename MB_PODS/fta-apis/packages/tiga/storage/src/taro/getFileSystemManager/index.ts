import Taro from '@tarojs/taro'
import { fileManager } from '../../files/fileManager'

function getFileSystemManager(): Taro.FileSystemManager {
  return fileManager
}

export { getFileSystemManager }
