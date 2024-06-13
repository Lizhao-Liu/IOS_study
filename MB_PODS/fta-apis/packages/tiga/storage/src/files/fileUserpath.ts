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
    return
  }

  /**
   * decodeToAbsolutePath
   * 根据路径 获取绝对路径，如果传入的不符合Tiga路径规则将直接返回
   */
  public async decodeToAbsolutePath(context: any, path: string): Promise<string> {
    return
  }
}

export const sandboxDir: SandBoxCacheClass = new SandBoxCacheClass()
