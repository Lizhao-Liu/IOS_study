
import Taro from '@tarojs/taro'
import React from 'react'
import Tiga from '../tiga/tiga/src'

const C = () => { }

// Tiga
export const System_GetCalendarEventProps = C as React.FC<Tiga.System.GetCalendarEventOption>
export const System_RemovePhoneCalendarEventProps = C as React.FC<Tiga.System.RemovePhoneCalendarEventOption>
export const System_GetAllContactsProps = C as React.FC<Tiga.System.ContactsProps>
export const System_OnCallStatusChangeProps = C as React.FC<Tiga.System.PhoneObserverOption>
export const System_SendSmsProps = C as React.FC<Tiga.System.SmsProps>
export const System_SettingPropsProps = C as React.FC<Tiga.System.SettingProps>
export const System_CheckIsOpenAccessibilitySuccessCallbackResult = C as React.FC<Taro.checkIsOpenAccessibility.SuccessCallbackResult>

// Taro
export const System_AccessibilityProps = C as React.FC<Taro.checkIsOpenAccessibility.Option>
export const System_AddPhoneCalendarProps = C as React.FC<Taro.addPhoneCalendar.Option>
export const System_AddPhoneRepeatCalendarProps = C as React.FC<Taro.addPhoneRepeatCalendar.Option>
export const System_SetClipboardDataProps = C as React.FC<Taro.setClipboardData.Option>
export const System_GetClipboardDataProps = C as React.FC<Taro.getClipboardData.Option>
export const System_ChooseContactProps = C as React.FC<Taro.chooseContact.Option>
export const System_MakePhoneCallProps = C as React.FC<Taro.makePhoneCall.Option>
export const System_SetScreenBrightnessProps = C as React.FC<Taro.setScreenBrightness.Option>
export const System_GetScreenBrightnessProps = C as React.FC<Taro.getScreenBrightness.Option>
export const System_SetKeepScreenOnProps = C as React.FC<Taro.setKeepScreenOn.Option>
export const System_SystemInfoAsyncProps = C as React.FC<Taro.getSystemInfoAsync.Option>
export const System_VibrateShortProps = C as React.FC<Taro.vibrateShort.Option>
export const System_VibrateLongProps = C as React.FC<Taro.vibrateLong.Option>

