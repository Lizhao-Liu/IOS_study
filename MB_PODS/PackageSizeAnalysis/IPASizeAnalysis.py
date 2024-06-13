# coding: utf8

#!/usr/bin/python


import os
import shutil
import zipfile
import sys
import json
import requests

# 解压
def un_zip(file_name):
    """unzip zip file"""
    zip_file = zipfile.ZipFile(file_name)
    if os.path.isdir(file_name + "_files"):
        pass
    else:
        os.mkdir(file_name + "_files")
    for names in zip_file.namelist():
        zip_file.extract(names, file_name + "_files/")
    zip_file.close()


# 解压后大小
def getFileFolderSize(fileOrFolderPath):
    totalSize = 0

    if not os.path.exists(fileOrFolderPath):
        return totalSize

    if os.path.isfile(fileOrFolderPath):
        totalSize = os.path.getsize(fileOrFolderPath)  # 5041481
        return totalSize

    if os.path.isdir(fileOrFolderPath):
        with os.scandir(fileOrFolderPath) as dirEntryList:
            for curSubEntry in dirEntryList:
                curSubEntryFullPath = os.path.join(fileOrFolderPath, curSubEntry.name)
                if curSubEntry.is_dir():
                    curSubFolderSize = getFileFolderSize(curSubEntryFullPath)  # 5800007
                    totalSize += curSubFolderSize
                elif curSubEntry.is_file():
                    curSubFileSize = os.path.getsize(curSubEntryFullPath)  # 1891
                    totalSize += curSubFileSize

            return totalSize


# 资源文件总大小
def getResourceSize(folderPath, blackFileName):
    sumsize = getFileFolderSize(folderPath)
    path = folderPath + "/" + blackFileName
    blacksize = getFileFolderSize(path)
    return (sumsize - blacksize) / 1024 / 1024


# 二进制文件总大小
def getMachOSize(folderPath, machFileName):
    path = folderPath + "/" + machFileName
    blacksize = getFileFolderSize(path)
    return blacksize / 1024 / 1024


def walkBundle(appPath):
    bundles_dic = {}
    for root, dirs, files in os.walk(appPath):
        for d in dirs:
            if d.find('.bundle') >= 0:
                path = appPath + '/' + d
                try:
                    if d not in bundles_dic:
                        size = os.path.getsize(path)
                        size2 = getFileFolderSize(path)/1024
                        info = {'name': d, 'size': size2}
                        bundles_dic[d] = info
                except IOError:
                    print('')
    return list(bundles_dic.values())
def analysisIPA(ipa_filepath, app_name, app_code_type):
    ipaInfo = {}
    baseInfo = {}
    resList = []
    newpath = ipa_filepath + ".zip"
    ipaSize = getFileFolderSize(ipa_filepath) / 1024/1024
    print("[INFO]ipa大小：" + str(ipaSize))
    shutil.copy(ipa_filepath, newpath)
    un_zip(newpath)
    unzippath = newpath + "_files"
    unzipFileName = newpath + '_files/Payload/' + app_name + ".app"
    unzipSize = getFileFolderSize(unzipFileName) / 1024 / 1024
    print("INFO]解压后大小：" + str(getFileFolderSize(unzipFileName) / 1024 / 1024))
    resSize = getResourceSize(unzipFileName, app_name)
    print("INFO]资源文件大小：" + str(resSize))

    machSize = getMachOSize(unzipFileName, app_name)
    print("INFO]二进制文件大小：" + str(machSize))
    bundles = walkBundle(unzipFileName)
    # shutil.rmtree(unzippath)
    os.remove(newpath)
    for bundle in bundles:
        print("[INFO]Bundle文件大小 name = " + bundle['name'] + " size = " + str(bundle['size']))
        dict = {}
        dict['resourceName'] = bundle['name']
        dict['resourceSize'] = bundle['size']
        dict['appCodeType'] = app_code_type
        resList.append(dict)

    baseInfo['ipaFileSize'] = ipaSize
    baseInfo['unzipFileSize'] = unzipSize
    baseInfo['resourceFileSize'] = resSize
    baseInfo['binaryFileSize'] = machSize
    ipaInfo['appIosVersionRecord'] = baseInfo
    ipaInfo['appIosResourceRecords'] = resList
    return ipaInfo

