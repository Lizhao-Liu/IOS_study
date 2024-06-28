# Xcode 12.3
# Build version 12C33
# Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
# Target: x86_64-apple-darwin19.4.0

Pod::Spec.new do |s|
  s.name = "MBFoundation"
  s.version = "0.9.0-beta1"
  s.summary = "MBFoundation"
  s.description = <<-DESC
    MBFoundation框架完整定义并提供了一套iOS开发常用基础API集合，包括但不限于基本数据类型、结构体、类、对象、时间日期处理、文件系统、内存安全管理、归档存储、异步协程机制等相关功能。
    DESC
  s.homepage = "https://code.amh-group.com/iOSYmm/MBFoundation"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "shixuan.bie" => "shixuan.bie@amh-group.com" }
  s.source = { :git => "git@code.amh-group.com:iOSYmm/MBFoundation.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.swift_version = "5.0"
  s.ios.deployment_target = "10.0"

  s.default_subspecs = "Util", "SafeExtensions", "Extensions", "Algorithm", "Global", "ContactsKit", "CoreTelephonyKit", "Collection", "OpenUDID", "SwiftyJSON", "Protocols", "HTMLParser", "ManagerCenter", "ToolKit", "Zip", "Hook"

  s.subspec "Util" do |ss|
    ss.source_files = "MBFoundation/Classes/Util/*.{h,m,swift}"
    ss.frameworks = "Foundation"
  end

  s.subspec "Extensions" do |ss|
    ss.source_files = "MBFoundation/Classes/Extensions/*.swift"
    ss.frameworks = "Foundation", "CoreFoundation"
    ss.dependency "MBFoundation/Algorithm"
    ss.dependency "MBFoundation/Global"
    ss.dependency "MBFoundation/ToolKit"
  end

  s.subspec "SafeExtensions" do |ss|
    ss.private_header_files = "MBFoundation/Classes/SafeExtensions/**/*.h"
    ss.source_files = "MBFoundation/Classes/SafeExtensions/**/*.{h,m}"
    ss.frameworks = "Foundation"
    ss.dependency "MBFoundation/Util"
  end

  s.subspec "Algorithm" do |ss|
    ss.source_files = "MBFoundation/Classes/Algorithm/*.swift"
    ss.frameworks = "Foundation", "Security"
  end

  s.subspec "Global" do |ss|
    ss.source_files = "MBFoundation/Classes/Global/*"
    ss.frameworks = "Foundation"
  end

  s.subspec "ContactsKit" do |ss|
    ss.source_files = "MBFoundation/Classes/ContactsKit/*.swift"
    ss.frameworks = "Foundation", "Contacts"
  end

  s.subspec "CoreTelephonyKit" do |ss|
    ss.source_files = "MBFoundation/Classes/CoreTelephonyKit/*.swift"
    ss.frameworks = "Foundation", "CoreTelephony"
  end

  s.subspec "Collection" do |ss|
    ss.source_files = "MBFoundation/Classes/Collection/*.swift"
    ss.frameworks = "Foundation"
  end

  s.subspec "OpenUDID" do |ss|
    ss.source_files = "MBFoundation/Classes/OpenUDID/*"
    ss.requires_arc = false
    ss.frameworks = "Foundation"
  end

  s.subspec "Protocols" do |ss|
    ss.source_files = "MBFoundation/Classes/Protocols/*.swift"
  end

  s.subspec "SwiftyJSON" do |ss|
    ss.source_files = "MBFoundation/Classes/SwiftyJSON/*.swift"
  end

  s.subspec "HTMLParser" do |ss|
    ss.source_files = "MBFoundation/Classes/HTMLParser/*.swift"
  end

  s.subspec "ManagerCenter" do |ss|
    ss.source_files = "MBFoundation/Classes/ManagerCenter/*"
  end

  s.subspec "ToolKit" do |ss|
    ss.source_files = "MBFoundation/Classes/ToolKit/**/*"
    ss.frameworks = "Foundation"
    ss.dependency "Reachability"
  end
  
  s.subspec "Zip" do |ss|
    ss.source_files = "MBFoundation/Classes/Zip/**/*"
    ss.dependency "PLzmaSDK", '~> 1.3', '>= 1.3.0.3'
  end
  
  s.subspec "Hook" do |ss|
    ss.source_files = "MBFoundation/Classes/Hook/**/*"
  end
  
  s.resource_bundle = { "MBFoundation" => ["README.md"] }
  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => "$(inherited) $(BUILT_PRODUCTS_DIR)/$(CONTENTS_FOLDER_PATH)/Headers"}
  s.script_phases = [
    {
      #脚本1：读取Manifest.lock文件，主要用来Release包读取插件的正式版本号（只识别了HCB\YMM\MB\WLJsSdk相关插件，后期考虑是否全部识别，包括3rd插件）
      :name => "Get plugin info - Manifest.lock",
      :shell_path => "/bin/sh",
      :execution_position => :before_compile,
      :script => "" '
      # Bundle file name
      bundle_file="MBFoundation.bundle"
      # Pods plugin info file name
      plugin_info_file="plugin_info"
      # Get Manifest.lock file path
      pod_manifest_lock_path=$(find "${PODS_ROOT}" -iname "Manifest.lock")
      # Get pod resource bundle directory
      pod_resource_bundle_dir=$(find "${CONFIGURATION_BUILD_DIR}" -iname "${bundle_file}")
      # Get pod resource bundle plugin info file path
      pod_resource_bundle_plugin_info_path="${pod_resource_bundle_dir}/${plugin_info_file}"
      # Get app (main) bundle dir
      app_bundle_dir=$(find "${PODS_CONFIGURATION_BUILD_DIR}" -iname "*.app")

      if [[ -f $pod_manifest_lock_path ]] && [[ -d $pod_resource_bundle_dir ]]; then
        # Get pods plugin info
        plugin_info=$(cat $pod_manifest_lock_path | egrep "^\s{2}\-\s(HCB\w+|YMM\w+|MB\w+|WLJsSdk)(\/\w+)?\s\((\d\.?)+(-(beta|dev))?(\d)*\):?" | sed "s/-//" | sed "s/[ \t]*//" | tr -d "\-:")
        echo "Cocoapods hcb plugin info:"
        echo "${plugin_info}"

        # Write plugin info to pod resource bundle
        echo "Write plugin info to pod resource bundle"
        if [[ -f $pod_resource_bundle_plugin_info_path  ]]; then
          rm $pod_resource_bundle_plugin_info_path
        fi
        echo "${plugin_info}" > $pod_resource_bundle_plugin_info_path

        # Write plugin info to pod resource bundle in app bundle
        if [[ -d $app_bundle_dir ]]; then
          app_bundle_pod_resource_bundle_dir=$(find "${app_bundle_dir}" -iname "${bundle_file}")
          if [[ -d $app_bundle_pod_resource_bundle_dir ]]; then
            echo "Write plugin info to pod resource bundle in app bundle"
            app_bundle_plugin_info_path="${app_bundle_pod_resource_bundle_dir}/${plugin_info_file}"
            if [[ -f $app_bundle_plugin_info_path ]]; then
              rm $app_bundle_plugin_info_path
            fi
            echo "${plugin_info}" > $app_bundle_plugin_info_path
          fi
        fi
      fi

      # Print all env params
      echo "env: PODS_ROOT=${PODS_ROOT}"
      echo "env: PODS_CONFIGURATION_BUILD_DIR=${PODS_CONFIGURATION_BUILD_DIR}"
      echo "env: CONFIGURATION_BUILD_DIR=${CONFIGURATION_BUILD_DIR}"
      echo "env: bundle_file=${bundle_file}"
      echo "env: plugin_info_file=${plugin_info_file}"
      echo "env: pod_manifest_lock_path=${pod_manifest_lock_path}"
      echo "env: pod_resource_bundle_dir=${pod_resource_bundle_dir}"
      echo "env: pod_resource_bundle_plugin_info_path=${pod_resource_bundle_plugin_info_path}"
      echo "env: app_bundle_dir=${app_bundle_dir}"
      echo "env: app_bundle_pod_resource_bundle_dir=${app_bundle_pod_resource_bundle_dir}"
      echo "env: app_bundle_plugin_info_path=${app_bundle_plugin_info_path}"
      ' "",
    }, {
      # 脚本2：读取Podfile文件，主要用来非Release包读取插件的正式版本号、临时版本号、分支、commit等，方便调试面板实时查看
      :name => "Get plugin info - Podfile",
      :shell_path => "/bin/sh",
      :execution_position => :before_compile,
      :script => "" '
        
        # ${PODS_PODFILE_DIR_PATH} 获取不到podfile的当前目录，原因未知
        # ${SRCROOT} 暂时先使用此值，截取掉后缀5位字符 ‘/Pods’，剩余的即为Podfile文件当前所在文件夹路径
        srcroot="${PODS_ROOT}"
        podfile_dir_path=${srcroot: 0: ${#srcroot}-5}
        
        # Bundle file name
        bundle_file="MBFoundation.bundle"
        # Pods plugin info file name (Podfile)
        plugin_info_file_podfile="plugin_info_podfile"
        # Get Podfile file path
        pod_podfile_path="${podfile_dir_path}/Podfile"
        # Get pod resource bundle directory
        pod_resource_bundle_dir=$(find "${CONFIGURATION_BUILD_DIR}" -iname "${bundle_file}")
        # Get pod resource bundle plugin info file path
        pod_resource_bundle_plugin_info_path="${pod_resource_bundle_dir}/${plugin_info_file_podfile}"
        # Get app (main) bundle dir
        app_bundle_dir=$(find "${PODS_CONFIGURATION_BUILD_DIR}" -iname "*.app")

        if [[ -f $pod_podfile_path ]] && [[ -d $pod_resource_bundle_dir ]]; then
          # Get pods plugin info
          plugin_info_podfile=$(cat $pod_podfile_path)
          echo "Cocoapods podfile info:"
          echo "${plugin_info_podfile}"

          # Write plugin info to pod resource bundle
          echo "Write plugin info to pod resource bundle"
          if [[ -f $pod_resource_bundle_plugin_info_path  ]]; then
            rm $pod_resource_bundle_plugin_info_path
          fi
          
          echo "${plugin_info_podfile}" > $pod_resource_bundle_plugin_info_path
  #        echo "1 ${SRCROOT} 2 ${PROJECT_DIR} 3 ${CONFIGURATION_BUILD_DIR} 4 ${PODS_CONFIGURATION_BUILD_DIR} 5 ${PODS_PODFILE_DIR_PATH} end"
  #        1 /Users/ymm/Desktop/MBNewOne/Pods
  #        2 /Users/ymm/Desktop/MBNewOne/Pods
  #        3 /Users/ymm/Library/Developer/Xcode/DerivedData/MBNewOne-bnewisscqzmtnhcgexlfibhfzpyx/Build/Products/Debug-iphonesimulator/MBToolKit
  #        4 /Users/ymm/Library/Developer/Xcode/DerivedData/MBNewOne-bnewisscqzmtnhcgexlfibhfzpyx/Build/Products/Debug-iphonesimulator
  #        5  end

          # Write plugin info to pod resource bundle in app bundle
          if [[ -d $app_bundle_dir ]]; then
            app_bundle_pod_resource_bundle_dir=$(find "${app_bundle_dir}" -iname "${bundle_file}")
            if [[ -d $app_bundle_pod_resource_bundle_dir ]]; then
              echo "Write plugin info to pod resource bundle in app bundle"
              app_bundle_plugin_info_path="${app_bundle_pod_resource_bundle_dir}/${plugin_info_file_podfile}"
              if [[ -f $app_bundle_plugin_info_path ]]; then
                rm $app_bundle_plugin_info_path
              fi
              echo "${plugin_info_podfile}" > $app_bundle_plugin_info_path
            fi
          fi
        fi

        # Print all env params
        echo "env: PODS_PODFILE_DIR_PATH=${PODS_PODFILE_DIR_PATH}"
        echo "env: PODS_ROOT=${PODS_ROOT}"
        echo "env: PODS_CONFIGURATION_BUILD_DIR=${PODS_CONFIGURATION_BUILD_DIR}"
        echo "env: CONFIGURATION_BUILD_DIR=${CONFIGURATION_BUILD_DIR}"
        echo "env: bundle_file=${bundle_file}"
        echo "env: plugin_info_file_podfile=${plugin_info_file_podfile}"
        echo "env: pod_resource_bundle_dir=${pod_resource_bundle_dir}"
        echo "env: pod_resource_bundle_plugin_info_path=${pod_resource_bundle_plugin_info_path}"
        echo "env: app_bundle_dir=${app_bundle_dir}"
        echo "env: app_bundle_pod_resource_bundle_dir=${app_bundle_pod_resource_bundle_dir}"
        echo
        ' "",
    }, {
      #脚本3：读取Manifest.lock文件
      :name => "Get all plugin info - Manifest.lock",
      :shell_path => "/bin/sh",
      :execution_position => :before_compile,
      :script => "" '
        # Bundle file name
        bundle_file="MBFoundation.bundle"
        # Pods plugin info file name
        plugin_info_file="plugin_info_manfiest"
        # Get Manifest.lock file path
        pod_manifest_lock_path=$(find "${PODS_ROOT}" -iname "Manifest.lock")
        # Get pod resource bundle directory
        pod_resource_bundle_dir=$(find "${CONFIGURATION_BUILD_DIR}" -iname "${bundle_file}")
        # Get pod resource bundle plugin info file path
        pod_resource_bundle_plugin_info_path="${pod_resource_bundle_dir}/${plugin_info_file}"
        # Get app (main) bundle dir
        app_bundle_dir=$(find "${PODS_CONFIGURATION_BUILD_DIR}" -iname "*.app")

        if [[ -f $pod_manifest_lock_path ]] && [[ -d $pod_resource_bundle_dir ]]; then
          # Get pods plugin info
          plugin_info=$(cat $pod_manifest_lock_path)
          echo "Cocoapods all plugin info:"
          echo "${plugin_info}"

          # Write plugin info to pod resource bundle
          echo "Write plugin info to pod resource bundle"
          if [[ -f $pod_resource_bundle_plugin_info_path  ]]; then
            rm $pod_resource_bundle_plugin_info_path
          fi
          echo "${plugin_info}" > $pod_resource_bundle_plugin_info_path

          # Write plugin info to pod resource bundle in app bundle
          if [[ -d $app_bundle_dir ]]; then
            app_bundle_pod_resource_bundle_dir=$(find "${app_bundle_dir}" -iname "${bundle_file}")
            if [[ -d $app_bundle_pod_resource_bundle_dir ]]; then
              echo "Write plugin info to pod resource bundle in app bundle"
              app_bundle_plugin_info_path="${app_bundle_pod_resource_bundle_dir}/${plugin_info_file}"
              if [[ -f $app_bundle_plugin_info_path ]]; then
                rm $app_bundle_plugin_info_path
              fi
              echo "${plugin_info}" > $app_bundle_plugin_info_path
            fi
          fi
        fi

        # Print all env params
        echo "env: PODS_ROOT=${PODS_ROOT}"
        echo "env: PODS_CONFIGURATION_BUILD_DIR=${PODS_CONFIGURATION_BUILD_DIR}"
        echo "env: CONFIGURATION_BUILD_DIR=${CONFIGURATION_BUILD_DIR}"
        echo "env: bundle_file=${bundle_file}"
        echo "env: plugin_info_file=${plugin_info_file}"
        echo "env: pod_manifest_lock_path=${pod_manifest_lock_path}"
        echo "env: pod_resource_bundle_dir=${pod_resource_bundle_dir}"
        echo "env: pod_resource_bundle_plugin_info_path=${pod_resource_bundle_plugin_info_path}"
        echo "env: app_bundle_dir=${app_bundle_dir}"
        echo "env: app_bundle_pod_resource_bundle_dir=${app_bundle_pod_resource_bundle_dir}"
        echo "env: app_bundle_plugin_info_path=${app_bundle_plugin_info_path}"
        ' "",

    },
  ]
end

# spec.static_framework = true
