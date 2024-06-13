import { TigaGeneral } from '@fta/tiga-util';
import Taro from '@tarojs/taro';
import React from 'react';
import Tiga from '../tiga/tiga/src';

const C = ()=> {}

export const Navigator_NavigateOption = C as React.FC<Tiga.Navigator.navigate.Option>
export const Navigator_PopOption = C as React.FC<Tiga.Navigator.pop.Option>
export const Navigator_PushOption = C as React.FC<Tiga.Navigator.push.Option>
export const Navigator_PopUntilOption = C as React.FC<Tiga.Navigator.popUntil.Option>
type GetAppPagesOptionType = TigaGeneral.Option<Tiga.Navigator.getAppPages.CallbackResult>
export const Navigator_GetAppPagesOption = C as React.FC<GetAppPagesOptionType>

export const Navigator_NavigateBackOption = C as React.FC<Taro.navigateBack.Option>
export const Navigator_NavigateToOption = C as React.FC<Taro.navigateTo.Option>
export const Navigator_RedirectToOption = C as React.FC<Taro.redirectTo.Option>
