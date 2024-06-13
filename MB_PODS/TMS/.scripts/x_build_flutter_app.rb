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
def install_flutter_app    
    flutter_application_path = File.expand_path("./",".flutter/app")
    flutter_application_branch = FLUTTER_APP_BRANCH

    File.expand_path(FLUTTER_APP_PATH)
    if File.exist?(FLUTTER_APP_PATH) 
        flutter_application_path = FLUTTER_APP_PATH
    else
        flutter_application_path = File.expand_path(FLUTTER_APP_PATH)
        if !File.exist?(flutter_application_path) 
            raise "Error: #{FLUTTER_APP_PATH} 地址不存在!"
        end
    end
  
    _now = Time.now.to_i
    puts "正在编译Thresh App插件 - #{flutter_application_path} \n此过程较慢(预计2分钟) 请耐心等️待☕️️️️️☕️☕️ #{Time.now}"

    `export PUB_HOSTED_URL=https://pub.flutter-io.cn && \
    export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn && \
    cd #{flutter_application_path} && \
    chmod -R 777 #{flutter_application_path}/* && \
    flutter packages get && \
    sh #{flutter_application_path}/shell_ios/x_build_ios_app.sh -m release`

    puts "共耗时#{(Time.now.to_i - _now)/60}分#{(Time.now.to_i - _now)%60}秒 \n"

    flutter_package_path = flutter_application_path+"/.build_ios/release/product"

    # 开始安装
    install_flutter_app_pod(flutter_package_path)
end

# 将 Flutter app 通过 pod 安装
def install_flutter_app_pod(product_path)
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

install_flutter_app()