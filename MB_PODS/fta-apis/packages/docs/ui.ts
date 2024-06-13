import Taro from '@tarojs/taro';
import React from 'react';
import Tiga from '../tiga/tiga/src';


const C = ()=> {}

export const UI_DialogOption = C as React.FC<Tiga.UI.DialogOption>
export const UI_StatusDialogOption = C as React.FC<Tiga.UI.StatusDialogOption>
export const UI_DialogButton = C as React.FC<Tiga.UI.DialogButton>
export const UI_DialogContentStyle = C as React.FC<Tiga.UI.DialogContentStyle>

export const UI_TaroShowLoadingOption = C as React.FC<Taro.showLoading.Option>
export const UI_TaroHideLoadingOption = C as React.FC<Taro.hideLoading.Option>
export const UI_TaroShowToastOption = C as React.FC<Taro.showToast.Option>
export const UI_TaroHideToastOption = C as React.FC<Taro.hideToast.Option>
export const UI_TaroShowModalOption = C as React.FC<Taro.showModal.Option>
export const UI_TaroShowActionSheetOption = C as React.FC<Taro.showActionSheet.Option>
