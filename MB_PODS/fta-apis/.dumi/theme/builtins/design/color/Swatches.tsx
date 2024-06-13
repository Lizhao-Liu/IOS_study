import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { SketchPicker } from 'react-color'
import tinycolor from 'tinycolor2'
import { SquareBlock, SquareBlockContainer } from './SquareBlock'
import { getColorList } from './utils'

interface Color {
  hex: string
  hsl: {
    a: number
    h: number
    l: number
    s: number
  }
  hsv: {
    a: number
    h: number
    s: number
    v: number
  }
  oldHue: number
  rgb: {
    r: number
    g: number
    b: number
    a: number
  }
  source: string
}

// 色板
export default function Swatches(): JSX.Element {
  // 默认选择运满满品牌色
  const [color, setColor] = useState(
    '#0154FE'
    // Math.random() > 0.5 ? '#FA871E' : '#FFD338'
  )
  const ref = useRef<HTMLElement>(null)
  const [visible, toggleVisible] = useState(false)

  const colorInfo = useMemo(() => tinycolor(color).toHsv(), [color])

  const onColorChange = (color: Color) => {
    setColor(color.hex.toUpperCase())
  }

  const toggleColorPicker = useCallback(
    (e: MouseEvent) => {
      // @ts-ignore
      const path = e.path
      if (path && !path.includes(ref.current) && visible) {
        toggleVisible(false)
      }
    },
    [visible, toggleVisible]
  )

  useEffect(() => {
    document.addEventListener('click', toggleColorPicker)
    return () => {
      document.removeEventListener('click', toggleColorPicker)
    }
  }, [visible, toggleVisible])

  return (
    <section style={{ position: 'relative' }}>
      {/* <h4 style={{ textAlign: 'center', width: 912 }}>请选择你的主色</h4> */}
      <SquareBlockContainer>
        {getColorList(color).map((v, i) => (
          <SquareBlock
            key={i}
            title={`color-${i + 1}`}
            textcolor={i < 4 ? '#1f1f1f' : '#fff'}
            val={v.toUpperCase()}
          />
        ))}
      </SquareBlockContainer>

      <span style={{ marginTop: 24, display: 'block' }}>
        <span
          style={{
            // padding: 4,
            backgroundColor: '#fff',
            borderRadius: 4,
            // boxShadow: 'rgba(0, 0, 0, 0.1) 0px 0px 0px 1px',
            display: 'inline-block',
            cursor: 'pointer',
            verticalAlign: 'middle',
            overflow: 'hidden',
          }}
          onClick={(e) => {
            e.stopPropagation()
            toggleVisible(!visible)
          }}>
          <span style={{ width: 120, height: 32, display: 'block', backgroundColor: color }}></span>
        </span>
        <span
          style={{
            marginLeft: 16,
            fontSize: 14,
            verticalAlign: 'middle',
            lineHeight: '22px',
            userSelect: 'all',
            color: '#141414',
          }}>
          {color}{' '}
          <span style={{ color: '#ff4d4f', verticalAlign: 'middle', marginLeft: 14 }}>
            {colorInfo.s < 0.7
              ? `饱和度建议不低于70（现在 ${((colorInfo.s as number) * 100).toFixed(2)}）`
              : ''}{' '}
            {colorInfo.v < 0.7
              ? `亮度建议不低于70（现在 ${((colorInfo.v as number) * 100).toFixed(2)}）`
              : ''}
          </span>
        </span>
        <span
          ref={ref}
          className='fta-color-picker'
          style={{
            position: 'absolute',
            display: visible ? 'block' : 'none',
            backgroundColor: '#fff',
            zIndex: 9,
            marginTop: 12,
          }}>
          <SketchPicker color={color} onChange={onColorChange} />
        </span>
      </span>
    </section>
  )
}
