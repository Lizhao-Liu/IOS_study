##############################################################################
#
# 脚本使用方式：
# 你需要在 Podfile 添加以下=begin =end 之间的内容：
=begin 

# 是否进行调试 flutter app，
# 为true时，为使用产物的方式从下面git地址拉取产物
# 为false时，为使用源码的方式从下面git地址拉取源码
FLUTTER_DEBUG_APP=false

# Flutter App git地址，从git拉取的内容放在当前工程目录下的.flutter/app目录
# 如果指定了FLUTTER_APP_PATH，则此配置失效
FLUTTER_APP_URL="git://xxx.git"
# flutter git 分支，默认为master
# 如果指定了FLUTTER_APP_PATH，则此配置失效
FLUTTER_APP_BRANCH="master"

# flutter本地工程目录，绝对路径或者相对路径，
# FLUTTER_DEBUG_APP == true时才有效，如果 != nil 则git相关的配置无效
FLUTTER_APP_PATH=nil

eval(File.read(File.join(__dir__, 'flutterhelper.rb')), binding)
=end
# 
# Flutter App git地址，从git拉取的内容放在当前工程目录下的.flutter/app目录
# 如果指定了FLUTTER_APP_PATH，则此配置失效
FLUTTER_APP_URL="git@code.amh-group.com:iOSYmm/MBFlutterFrameworks.git"
FLUTTER_SRC_URL="git@code.amh-group.com:MBFrontend/Flutter/mbflutter_host.git"

#存放release 产物的git目录
FLUTTER_RELEASE_GIT_PATH="Frameworks/Flutter/"
##############################################################################

# 拉取代码方法

def update_flutter_app(path, url, branche)

    if FLUTTER_NEED_UPDATE != nil && FLUTTER_NEED_UPDATE == true
        puts "output path = #{path} \n"
        `sh ./.scripts/update_flutter_app.sh #{path} #{url} #{branche}`
    else
        puts "本次pod 没有更新flutter 产物"
    end
end

# 安装开发环境app
def install_debug_flutter_app

    puts "如果是第一次运行开发环境Flutter项目，此过程可能会较慢"
    puts "请耐心等️待☕️️️️️☕️☕️\n"
    
    # 默认Flutter App 目录
    flutter_application_path = File.expand_path("./",".flutter/app")
    # flutter_application_url = FLUTTER_APP_URL #"git@code.ymmoa.com:gangtao.zhou/driver_flutter_module.git"
    flutter_application_branch = FLUTTER_APP_BRANCH
    puts "flutter debug\n"
    if FLUTTER_APP_PATH != nil
        puts "flutter local path"+FLUTTER_APP_PATH
        File.expand_path(FLUTTER_APP_PATH)
        if File.exist?(FLUTTER_APP_PATH) 
            flutter_application_path = FLUTTER_APP_PATH
            puts "flutter_application_path"+flutter_application_path
        else
            flutter_application_path = File.expand_path(FLUTTER_APP_PATH)
            if !File.exist?(flutter_application_path) 
                raise "Error: #{FLUTTER_APP_PATH} 地址不存在!"
            end
        end
        
        puts "\nFlutter App路径: "+flutter_application_path
    else
        if FLUTTER_SRC_URL != nil
            puts "\nFlutter git url: "+FLUTTER_SRC_URL
            flutter_application_url = FLUTTER_SRC_URL
            if FLUTTER_APP_BRANCH != nil
                flutter_application_branch = FLUTTER_APP_BRANCH
            end
        else
            raise "Error: 请在'Podfile'里增加YMMFlutterShipperLib git地址配置"
        end
        
        puts "\n拉取 Flutter App 代码"
        puts "Flutter App路径: "+flutter_application_path
        puts "\nflutter_application_url: "+flutter_application_url
        puts "\nflutter_application_branch: "+flutter_application_branch
        update_flutter_app(flutter_application_path, flutter_application_url, flutter_application_branch)
    end

    puts "\n编译 Flutter App"
    puts "\nflutter_application_path = "+flutter_application_path

    `export PUB_HOSTED_URL=https://pub.flutter-io.cn && \
    export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn && \
    cd #{flutter_application_path} && \
    chmod -R 777 #{flutter_application_path}/* && \
    flutter packages get && \
    sh #{flutter_application_path}/shell_ios/build_ios_module.sh -m debug`

    flutter_package_path = flutter_application_path+"/.build_ios/debug/product"

    puts "\flutter_application_path = " + flutter_application_path
    puts "\nflutter_package_path = " + flutter_package_path

    # 开始安装
    install_release_flutter_app_pod(flutter_package_path)

    # if $?.to_i == 0
    #     flutter_package_path = File.expand_path(#{flutter_application_path},".build_ios/debug/product") #{}"#{flutter_application_path}/.build_ios/debug/product"
    #     # 开始安装
    #     install_release_flutter_app_pod(flutter_package_path)
    # else
    #     raise "Error: 编译 Flutter App失败"
    # end
end

# 将 Flutter app 通过 pod 安装
def install_release_flutter_app_pod(product_path)
    if product_path.nil?
        raise "Error: 无效的 flutter app 目录"
    end

    puts "将 flutter app 通过 pod 导入到 工程"

    Dir.foreach product_path do |sub|
        # 忽略隐藏文件
        if sub =~ /\.(.*)/ 
            next
        end

        sub_abs_path = File.join(product_path, sub)
        pod sub, :path=>sub_abs_path
    end
end 

def deleteDirectory(dirPath)
  FileUtils.rm_rf(dirPath);
end

# def deleteDirectory(dirPath)
#   if File.directory?(dirPath)
#     Dir.foreach(dirPath) do |subFile|
#       if subFile != '.' and subFile != '..' 
#         deleteDirectory(File.join(dirPath, subFile));
#       end
#     end
#     FileUtils.rm_rf(dirPath);
#   else
#     File.delete(dirPath);
#   end
# end

# 安装正式环境环境app
def install_release_flutter_app
    if FLUTTER_APP_URL.nil?
        raise "Error: 请在 Podfile 里设置要安装的 Flutter app 的产物地址 ，例如：FLUTTER_APP_URL='git://xxx'"
    end

    flutter_app_url = FLUTTER_APP_URL

    # 存放产物的目录
    #flutter_package_path = "#{flutter_application_path}/.build_ios/debug/product"
    flutter_release_path = File.expand_path("./",'Frameworks/Flutter')
    #release 模式下产物分支   在Podfile中设置FLUTTER_APP_BRANCH
    #flutter_app_branch = "master"
    flutter_app_branch = FLUTTER_APP_BRANCH

    if FLUTTER_APP_BRANCH.nil?
        flutter_app_branch = "master"
    end

    update_flutter_app(flutter_release_path, flutter_app_url, flutter_app_branch)

    # 开始安装
    flutter_package_path = FLUTTER_RELEASE_GIT_PATH
    install_release_flutter_app_pod(flutter_package_path)
end

if FLUTTER_DEBUG_APP.nil? || FLUTTER_DEBUG_APP == false
    # 使用 flutter release 模式
    puts "开始安装 release mode flutter app"
    #deleteDirectory(File.join(Dir.getwd, '.flutter_release'));
    install_release_flutter_app()
else
    # 存在debug配置，使用 flutter debug 模式
    puts "开始安装 debug mode flutter app"
    deleteDirectory(File.join(Dir.getwd, '.flutter'));
    install_debug_flutter_app()
end


