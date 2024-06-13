import Taro from '@tarojs/taro'

export class StatInfo implements Taro.Stats {
  mode: string
  size: number
  lastAccessedTime: number
  lastModifiedTime: number

  private isDir: boolean

  constructor(data: any) {
    this.mode = data?.mode
    this.size = data?.size
    this.lastAccessedTime = data?.lastAccessedTime
    this.lastModifiedTime = data?.lastModifiedTime
    this.isDir = data?.isDir
  }

  isDirectory(): boolean {
    return this.isDir
  }
  isFile(): boolean {
    return !this.isDir
  }
}
