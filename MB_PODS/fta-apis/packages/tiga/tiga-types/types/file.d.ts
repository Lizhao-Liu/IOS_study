declare namespace Taro {
  namespace FileSystemManager {
    interface AccessOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface AppendFileOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface CopyFileOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface getFileInfoOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface MkdirOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface RmdirOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface ReaddirOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface ReadFileOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface RenameOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface SaveFileOption {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 要存储的文件路径, 本地用户路径, 必传参数 */
      filePath: string
    }

    interface StatOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface UnlinkOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }

    interface WriteFileOption {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
  }
}
