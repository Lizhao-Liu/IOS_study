# coding: utf8

import sys
import requests
import json
import LinkMapAnalysis
import IPASizeAnalysis


def print_help():
    print("%s" % "=".ljust(80, '='))
    print("%s%s\n" % ("".ljust(10), "满帮包体大小分析工具".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- Usage : python PackageSizeAnalysis.py <app_name> <app_version> <linkmap_filePath> <ipa_filePath> <app_downloadSize> <app_installSize>".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_name app名称 ".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_version ：app版本".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_version_code ：app版本号".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_code_type ：app标识".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_iteration_version ：app迭代版本日期".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- linkmap_filePath ：对应版本的linkmap文件路径".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- ipa_filePath ：对应版本的ipa文件路径".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_downloadSize ：对应版本的iphoneX机型对应的下载大小".ljust(80)))
    print("%s%s\n" % ("".ljust(10), "- app_installSize ：对应版本的iphoneX机型对应的安装大小".ljust(80)))
    print("%s" % "=".ljust(80, '='))

def send(content):
    print('begin send request cotent = \n' + content)
    r = requests.post('http://catter.amh-group.com/cat-daily/ymm/uploadIosVersionInfo',content)
    print(r)
    print('end send')


def main():
    if len(sys.argv) < 10:
        print_help()
        return
        pass
    app_name = sys.argv[1]
    app_version = sys.argv[2]
    app_version_code = sys.argv[3]
    app_code_type = sys.argv[4]
    app_iteration_version = sys.argv[5]
    linkmap_filePath = sys.argv[6]
    ipa_filePath = sys.argv[7]
    app_downloadSize = sys.argv[8]
    app_installSize = sys.argv[9]
    print("[INFO]input arguments: \napp_name = %s\napp_version = %s\nlinkmap_filePath = %s\nipa_filePath = %s\napp_downloadSize = %s\napp_installSize = %s" % (app_name, app_version, linkmap_filePath, ipa_filePath, app_downloadSize, app_installSize))
    print("[INFO] analysis linkmap file")
    libs_info = LinkMapAnalysis.analysis(linkmap_filePath, app_code_type)
    print("[INFO] analysis ipa file")
    ipa_info = IPASizeAnalysis.analysisIPA(ipa_filePath, app_name, app_code_type)
    base_info = ipa_info['appIosVersionRecord']
    base_info['appCodeType'] = app_code_type
    base_info['versionName'] = app_version
    base_info['versionCode'] = app_version_code
    base_info['iterationVersion'] = app_iteration_version
    base_info['appStoreDownloadSize'] = app_downloadSize
    base_info['appStoreInstallSize'] = app_installSize
    ipa_info['appIosVersionRecord'] = base_info
    ipa_info['appIosLibRecords'] = libs_info
    sendStr = json.dumps(ipa_info)
    send(sendStr)
if __name__ == "__main__":
    main()