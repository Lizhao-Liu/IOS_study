
import { TigaGeneral } from '@fta/tiga-util';
import Taro from '@tarojs/taro';
import React from 'react';
import Tiga from '../tiga/tiga/src';

// 这行代码的作用是占住Taro的引用，不然taro原有的类型定义就没有了
const taro = Taro

const C = () => { }

export const TigaGeneral_CallbackResult = C as React.FC<TigaGeneral.CallbackResult>
export const TigaGeneralOption_CallbackResult = C as React.FC<TigaGeneral.Option<TigaGeneral.CallbackResult>>

// canIUse
export const CanIUseTigaOption = C as React.FC<Tiga.CanIUseTigaOption>
export const CanIUseTigaResult = C as React.FC<Tiga.CanIUseTigaResult>
export const CanIUseBizModuleOption = C as React.FC<Tiga.CanIUseBizModuleOption>
export const CanIUseBizModuleResult = C as React.FC<Tiga.CanIUseBizModuleResult>

// #region Common
// Tiga
export const Common_GetConfigOption = C as React.FC<Tiga.Common.GetConfigOption>

export const Common_RegisterActionOption = C as React.FC<Tiga.Common.RegisterActionOption>

export const Common_TigaGeneralOption_IsAppForegroundCallbackResult = C as React.FC<TigaGeneral.Option<Tiga.Common.IsAppForegroundCallbackResult>>

export const Common_GetBundleInfoOption = C as React.FC<Tiga.Common.GetBundleInfoOption>
export const Common_PluginInfoOption = C as React.FC<Tiga.Common.PluginInfoOption>


// Taro

// #endregion

// #region Storage
// Tiga
export const Storage_GetKvStorageOption = C as React.FC<Tiga.Storage.getKvStorage.Option>

// Taro

// #endregion

// #region Message
// Tiga
export const Message_MBLongConnHandleOption = C as React.FC<Tiga.Message.MBLongConnHandleOption>
export const Message_MBRemoveLongConnListenOption = C as React.FC<Tiga.Message.MBRemoveLongConnListenOption>

export const Message_MBPushHandleOption = C as React.FC<Tiga.Message.MBPushHandleOption>
export const Message_MBPushRemoveListenOption = C as React.FC<Tiga.Message.MBPushRemoveListenOption>
export const Message_MBPushConsumeOption = C as React.FC<Tiga.Message.MBPushConsumeOption>
export const Message_MBPushNotifiable = C as React.FC<Tiga.Message.MBPushNotifiable>
export const Message_MBPushFinishOption = C as React.FC<Tiga.Message.MBPushFinishOption>
export const Message_MBNotificationOption = C as React.FC<Tiga.Message.MBNotificationOption>
export const Message_MBSystemNotification = C as React.FC<Tiga.Message.MBSystemNotification>
export const Message_MBPausePushOption = C as React.FC<Tiga.Message.MBPausePushOption>
export const Message_MBPausePushResult = C as React.FC<Tiga.Message.MBPausePushResult>
export const Message_MBResumePushOption = C as React.FC<Tiga.Message.MBResumePushOption>

// #endregion


// Taro
export const TaroGeneralCallbackResult = C as React.FC<TaroGeneral.CallbackResult>

// #endregion


export * from './advertisement';
export * from './apm';
export * from './common';
export * from './download';
export * from './extend';
export * from './location';
export * from './media';
export * from './navigator';
export * from './network';
export * from './permission';
export * from './popup';
export * from './social';
export * from './system';
export * from './tabbar';
export * from './tracker';
export * from './ui';
export * from './util';

