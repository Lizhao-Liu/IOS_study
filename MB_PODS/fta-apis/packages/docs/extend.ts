/// <reference types="@types/fta-tiga" />

import React from "react"

const C = ()=> {}

// #region Storage
export const Storage_GetStorageInfoOption = C as React.FC<Taro.getStorageInfo.Option>
export const Storage_SetStorageOption = C as React.FC<Taro.setStorage.Option>

export const Storage_GetStorageOption = C as React.FC<Taro.getStorage.Option<any>>
export const Storage_RemoveStorageOption = C as React.FC<Taro.removeStorage.Option>
export const Storage_ClearStorageOption = C as React.FC<Taro.clearStorage.Option>

export const Storage_FileSystemManagerAccessOption = C as React.FC<Taro.FileSystemManager.AccessOption>
export const Storage_FileSystemManagerMkdirOption = C as React.FC<Taro.FileSystemManager.MkdirOption>
export const Storage_FileSystemManagerRmdirOption = C as React.FC<Taro.FileSystemManager.RmdirOption>
export const Storage_FileSystemManagerUnlinkOption = C as React.FC<Taro.FileSystemManager.UnlinkOption>
export const Storage_FileSystemManagerReaddirOption = C as React.FC<Taro.FileSystemManager.ReaddirOption>
export const Storage_FileSystemManagerAppendFileOption = C as React.FC<Taro.FileSystemManager.AppendFileOption>
export const Storage_FileSystemManagerReadFileOption = C as React.FC<Taro.FileSystemManager.ReadFileOption>
export const Storage_FileSystemManagerCopyFileOption = C as React.FC<Taro.FileSystemManager.CopyFileOption>
export const Storage_FileSystemManagerRenameOption = C as React.FC<Taro.FileSystemManager.RenameOption>
export const Storage_FileSystemManagerGetFileInfoOption = C as React.FC<Taro.FileSystemManager.getFileInfoOption>
export const Storage_FileSystemManagerSaveFileOption = C as React.FC<Taro.FileSystemManager.SaveFileOption>
export const Storage_FileSystemManagerStatOption = C as React.FC<Taro.FileSystemManager.StatOption>

// #endregion


// #region Navigator
export const Navigator_NavigateBackOption = C as React.FC<Taro.navigateBack.Option>
export const Navigator_NavigateToOption = C as React.FC<Taro.navigateTo.Option>
export const Navigator_RedirectToOption = C as React.FC<Taro.redirectTo.Option>
// #endregion
