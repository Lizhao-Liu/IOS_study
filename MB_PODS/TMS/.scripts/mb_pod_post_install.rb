##############################################################################
#
# 脚本使用方式：
# 你需要在 Podfile 添加以下=begin =end 之间的内容：
# 
##############################################################################
require 'pathname'

def modify_ijiami_filter_dirs_path(ijiami_config_file_path, pods_dir)
    puts "modify_ijiami_filter_dirs_path config file path = #{ijiami_config_file_path}, pods dir = #{pods_dir}"
    unless Pathname(ijiami_config_file_path).exist?
        return
    end
    config_file = File.read(ijiami_config_file_path)
    config_content = JSON.parse(config_file)
    puts "ijiami config file content:\n #{config_content}"

    filter_dirs = config_content['filter-dirs']

    puts "ijiami config filter-dirs:\m #{filter_dirs}"

    if filter_dirs == nil
        return
    end

    if filter_dirs.length > 0
        new_filter_dirs = filter_dirs.map do |filter_dir|
            new_filter_dir = filter_dir
            unless new_filter_dir.include?(pods_dir)
                new_filter_dir = pods_dir + '/' + filter_dir
            end
            new_filter_dir
        end
        puts "ijiami config new filter-dirs:\n #{new_filter_dirs}"

        config_content['filter-dirs'] = new_filter_dirs

        File.write(ijiami_config_file_path, JSON.dump(config_content))
    end
end

def mb_pod_post_install()
    #存放ijm default-config.json 文件目录
    puts "mb_pod_post_install release版本增加爱加密参数"
    jsonfile = File.expand_path("./",'.ijm/AJM_MBNewOne_Config.json')
    # 爱加密配置文件中filter_dirs为绝对路径，文件中使用相对路径，在此处修改为绝对路径，本地调试爱加密包时使用modify_ijiami_filter_dirs_path方法
    # modify_ijiami_filter_dirs_path(jsonfile, File.expand_path("./",'Pods'))
    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
                if config.name == 'AdHoc' || config.name == 'EnterpriseDebug' || config.name == 'inhouse' || config.name == 'Debug_27D27NC4P5_ShanghaiYunzhanggui' || config.name == 'Debug_33NTY77JS5_GuiyangHuochebang' || config.name == 'Debug_LJTDBM4U3C_ChengduYunli'
                    puts config.build_settings['ENABLE_NS_ASSERTIONS'] = "YES"
                end
                if config.name == 'EnterpriseDebug'
                    puts config.build_settings['ONLY_ACTIVE_ARCH'] = "YES"
                    puts config.build_settings['SWIFT_COMPILATION_MODE'] = 'Incremental'

                end
                if config.name == 'Release' || config.name == 'EnterpriseRelease'
                    puts config.build_settings['SWIFT_COMPILATION_MODE'] = 'Incremental'
                end
        end
        
        # installer.pods_project.targets.each do |target|
        #       compatibilityPhase = target.build_phases.find { |ph| ph.display_name == 'Copy generated compatibility header' }
        #       if compatibilityPhase
        #           build_phase = target.new_shell_script_build_phase('Copy Swift Generated Header')
        #           build_phase.shell_script = <<-SH.strip_heredoc
        #               COMPATIBILITY_HEADER_PATH="${BUILT_PRODUCTS_DIR}/Swift Compatibility Header/${PRODUCT_MODULE_NAME}-Swift.h"
        #               ditto "${COMPATIBILITY_HEADER_PATH}" "${PODS_ROOT}/Headers/Public/${PRODUCT_MODULE_NAME}/${PRODUCT_MODULE_NAME}-Swift.h"
        #           SH
        #       end
        # end
        
        installer.pods_project.targets.each do |target|
            if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle" # <--- this
              target.build_configurations.each do |config|
                  config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
              end
            end
            target.build_configurations.each do |config|
                config.build_settings["HEADER_SEARCH_PATHS"] = ["$(inherited)", "$(BUILT_PRODUCTS_DIR)/$(CONTENTS_FOLDER_PATH)/Headers"]
                
                config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
                config.build_settings['ENABLE_BITCODE'] = 'NO'
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
                config.build_settings['VALID_ARCHS'] = "arm64 arm64e x86_64"
				config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
                config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO' # 关闭文档检查
                config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'NO' #关闭本地化检查
                config.build_settings['OTHER_CPLUSPLUSFLAGS'] = ["$(OTHER_CFLAGS)", "-fcxx-modules"] #c++支持@import
#                config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
#                config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
                
                if config.name == 'AdHoc' || config.name == 'Debug' || config.name == 'Debug_33NTY77JS5_GuiyangHuochebang' || config.name == 'Debug_LJTDBM4U3C_ChengduYunli' || config.name == 'Debug_27D27NC4P5_ShanghaiYunzhanggui'
                  config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
                  config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-D', 'DEBUG', '-no-verify-emitted-module-interface']

                  config.build_settings['WARNING_CFLAGS'] = ['$(inherited)', '-Wno-ambiguous-macro']
                  config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'DEBUG=1']
                  config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
                end
                if config.name == 'EnterpriseRelease'
                  config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-sanitize=undefined', '-sanitize-coverage=func']
                  config.build_settings['OTHER_CFLAGS'] ||= [
                  "$(inherited)", "-ld_classic", '-fsanitize-coverage=func,trace-pc-guard'
                  ]
                end
                if config.name == 'EnterpriseDebug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-D', 'DEBUG']
                    config.build_settings['WARNING_CFLAGS'] = ['$(inherited)', '-Wno-ambiguous-macro']
                    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'DEBUG=1', 'EnterpriseDebug=1']
                    config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
                end
                if config.name == 'inhouse'
                    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)','INHOUSE=1','COCOAPODS=1','SQLITE_HAS_CODEC=1']
                end
                if config.name == 'Release' || config.name == 'EnterpriseRelease'
                    config.build_settings['OTHER_CFLAGS'] ||= [
                        "$(inherited)",
                        "-mllvm","-ipo",
                        "-mllvm","-ipo-percent=30",
                        "-mllvm","-ipo-loop=1",
                        "-mllvm","-ob-config-path=\""+jsonfile+"\"",
                        "-fembed-bitcode"]
                end
            end
        end
    end
end

mb_pod_post_install()



