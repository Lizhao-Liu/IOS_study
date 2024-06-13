import { message } from 'antd'
import 'antd/es/message/style/index'
import React from 'react'
import tinycolor from 'tinycolor2'

export function copyColor(val: string, title?: string) {
  copyTextAsync(val).then(() =>
    message.success(
      title ? (
        <span>
          {`@${title} copied: `} <span style={{ color: val }}>{val}</span>
        </span>
      ) : (
        <span>
          Copied: <span style={{ color: val }}>{val}</span>
        </span>
      )
    )
  )
}

const hueStep = 2
const saturationStep = 0.16
const saturationStep2 = 0.05
const brightnessStep1 = 0.05
const brightnessStep2 = 0.15
const lightColorCount = 5
const darkColorCount = 4

const getHue = function (hsv, i, isLight) {
  let hue
  if (hsv.h >= 60 && hsv.h <= 240) {
    hue = isLight ? hsv.h - hueStep * i : hsv.h + hueStep * i
  } else {
    hue = isLight ? hsv.h + hueStep * i : hsv.h - hueStep * i
  }
  if (hue < 0) {
    hue += 360
  } else if (hue >= 360) {
    hue -= 360
  }
  return Math.round(hue)
}

const getSaturation = function (hsv, i, isLight) {
  let saturation
  if (isLight) {
    saturation = hsv.s - saturationStep * i
  } else if (i === darkColorCount) {
    saturation = hsv.s + saturationStep
  } else {
    saturation = hsv.s + saturationStep2 * i
  }
  if (saturation > 1) {
    saturation = 1
  }
  if (isLight && i === lightColorCount && saturation > 0.1) {
    saturation = 0.1
  }
  if (saturation < 0.06) {
    saturation = 0.06
  }
  return Number(saturation.toFixed(2))
}

const getValue = function (hsv, i, isLight) {
  let value
  if (isLight) {
    value = hsv.v + brightnessStep1 * i
  } else {
    value = hsv.v - brightnessStep2 * i
  }
  if (value > 1) {
    value = 1
  }
  return Number(value.toFixed(2))
}

export const colorPalette = function (color, index) {
  var isLight = index <= 6
  var hsv = tinycolor(color).toHsv()
  var i = isLight ? lightColorCount + 1 - index : index - lightColorCount - 1
  return tinycolor({
    h: getHue(hsv, i, isLight),
    s: getSaturation(hsv, i, isLight),
    v: getValue(hsv, i, isLight),
  }).toHexString()
}

/** 根据主色获取颜色列表 */
export function getColorList(mainColor: string) {
  return new Array(10).fill(0).map((v, i) => colorPalette(mainColor, i + 1))
}

/** 异步写入剪切板 */
export function copyTextAsync(text: string) {
  return new Promise((resolve) => {
    if (navigator.clipboard) {
      // clipboard api 复制
      navigator.clipboard.writeText(text)
      resolve(null)
    } else {
      var textarea = document.createElement('textarea')
      document.body.appendChild(textarea)
      // 隐藏此输入框
      textarea.style.position = 'fixed'
      textarea.style.clip = 'rect(0 0 0 0)'
      textarea.style.top = '10px'
      // 赋值
      textarea.value = text
      // 选中
      textarea.select()
      // 复制
      document.execCommand('copy', true)
      // 移除输入框
      document.body.removeChild(textarea)
      resolve(null)
    }
  })
}
