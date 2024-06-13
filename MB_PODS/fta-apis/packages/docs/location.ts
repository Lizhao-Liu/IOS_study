
import { TigaGeneral } from '@fta/tiga-util';
import Taro from '@tarojs/taro';
import React from 'react';
import Tiga from '../tiga/tiga/src';

// 这行代码的作用是占住Taro的引用，不然taro原有的类型定义就没有了
const taro = Taro

const C = () => { }

// Tiga
export const Location_GeneralProps = C as React.FC<TigaGeneral.Option<Tiga.Location.LocationInfoCallbackResult>>
export const Location_LocationProps = C as React.FC<Tiga.Location.LocationProps>
export const Location_GeocoderProps = C as React.FC<Tiga.Location.GeocoderProps>
export const Location_WebGeocoderProps = C as React.FC<Tiga.Location.WebGeocoderProps>

export const Location_CodeProps = C as React.FC<Tiga.Location.CodeProps>
export const Location_NameProps = C as React.FC<Tiga.Location.NameProps>
export const Location_ChildrenProps = C as React.FC<Tiga.Location.ChildrenProps>


// Taro
export const Location_GetLocationProps = C as React.FC<Taro.getLocation.Option>
export const Location_GetFuzzyLocationProps = C as React.FC<Taro.getFuzzyLocation.Option>




