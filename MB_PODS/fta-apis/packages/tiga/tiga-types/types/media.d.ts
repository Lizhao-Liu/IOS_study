declare namespace Taro {
  namespace chooseImage {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 【APP 端内生效】图片大小上限，单位 B */
      maxSize?: number
      /** 【APP 端内生效】图片裁剪比例，如: 1:1，设置了会进入裁剪页面，未设置则不裁剪，图片多选的情况下不支持图片裁剪 */
      cropScale?: string
      /**
       * 【APP 端内生效】使用 自定义相机或者系统拍
       * @default system
       **/
      cameraType?: 'custom' | 'system'
      /**
       * 返回图片的类型
       * original: 返回原图
       * compressed: 返回压缩后的图片
       */
      sizeType?: Array<keyof sizeType>
      /**
       * 选择图片的来源
       * app 端内只支持 album(相册) 和 camera(相机)
       */
      sourceType?: Array<keyof sourceType>
    }
    interface ImageFile {
      /** 【APP 端内生效】原图文件路径 */
      originalFilePath?: string
    }
  }

  namespace chooseMedia {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 【APP 端内生效】图片大小上限，单位 B */
      maxSize?: number
      /** 【APP 端内生效】图片裁剪比例，如: 1:1，设置了会进入裁剪页面，未设置则不裁剪，图片多选的情况下不支持图片裁剪 */
      cropScale?: string
      /**
       * 【APP 端内生效】使用 自定义相机或者系统拍摄
       * @default "system"
       */
      cameraType?: 'custom' | 'system'
    }
    interface ChooseMedia {
      /** 【APP 端内生效】文件类型 */
      fileType?: string
      /** 【APP 端内生效】原图文件路径 */
      originalFilePath?: string
      /**
       * 视频时长，单位 毫秒
       * @since 1.5.0
       */
      duration: number
      /**
       * 视频的宽度
       * @since 1.5.0
       */
      width: number
      /**
       * 视频的高度
       * @since 1.5.0
       */
      height: number
    }
    interface mediaType {
      /** 可同时选择图片和视频 */
      mix
    }
  }

  namespace compressImage {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 【APP 端内生效】图片大小上限，单位 B，按参数压缩完之后，如果图片还大于 maxSize，则会忽视 quality 字段，继续压缩图片质量以满足 maxSize 要求 */
      maxSize?: number
    }
  }

  namespace cropImage {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
  }

  namespace getImageInfo {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
    interface SuccessCallbackResult {
      /** 【APP 端内生效】图片大小，单位 B */
      size?: number
      /** 【APP 端内生效】图片拍摄时间（时间戳） */
      timestamp?: number
      /** 【APP 端内生效】图片拍摄位置信息（取决图片是否携带） */
      location?: string
    }
  }

  namespace previewImage {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 是否显示菜单，小程序是长按菜单，端内是右上角菜单，默认值：true */
      showmenu?: boolean
    }
  }

  namespace previewMedia {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /**
       * 【APP 端内生效】
       * 右上角自定义菜单，当设置了此字段时，showmenu则无效
       * @since 1.4.0
       */
      menus?: Menu[]
      /**
       * 【APP 端内生效】
       * 右上角自定义菜单的点击回调，和menus字段组合使用，点击时会回调当前菜单 menuId、当前显示的 图片/视频 信息
       * @since 1.4.0
       */
      onMenuClick?: (menuId: string, source: Sources) => void
    }

    interface Sources {
      /**
       * 资源的类型（图片或视频）
       * @default image
       */
      type?: 'image' | 'video'
      /** 【APP 端内生效】视频/图片描述 */
      description?: string
    }

    interface Menu {
      /** 菜单id，用于区分不同的菜单 */
      id: string
      /** 菜单标题 */
      title: string
      /** 菜单图标 */
      icon: string
    }
  }

  namespace saveImageToPhotosAlbum {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
      /** 图片文件路径，可以是临时文件路径或永久文件路径，端内支持网络图片路径，小程序不支持网络图片路径 */
      filePath: string
    }
  }

  namespace saveVideoToPhotosAlbum {
    interface Option {
      /** 【APP 端内生效】页面 context */
      context?: any
    }
  }
}
