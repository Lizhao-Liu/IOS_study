import { Form, FormItem, Picker, Toggle } from '@fta/components'
import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useCallback, useRef, useState } from 'react'

function usePartialState<S>(initialState: S) {
  const [state, updateState] = useState(initialState)
  const setState = useCallback((newPartialState: Partial<S>) => {
    updateState((prevState) => ({ ...prevState, ...newPartialState }))
  }, [])

  return [state, setState] as const
}

function CalendarDemoBlock() {
  const context = useThreshContext()
  const formRef = useRef<any>()
  const [formStateBasic, setFormStateBasic] = usePartialState({
    title: '',
    startTime: '',
    endTime: '',
    allDay: true,
    description: '',
    location: '',
    alarm: false,
    alarmOffset: '0',
    repeat: false,
    repeatInterval: 'month',
    repeatEndTime: '',
  })

  const timeString = (timeStamp: number): string => {
    if (!timeStamp) {
      return ''
    }
    const date = new Date(timeStamp)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hour = String(date.getHours()).padStart(2, '0')
    const minute = String(date.getMinutes()).padStart(2, '0')
    const dateString = `${year}-${month}-${day} ${hour}:${minute}`
    console.log(dateString)
    return dateString
  }

  const timeStamp = (timeString: string): number => {
    let res = new Date(timeString).getTime()
    res = Math.floor(res / 1000)
    console.log('timeString' + timeString + '   timeStamp' + res)
    return res
  }

  const [calendarEvents, setCalendarEvents] = useState<any[]>([])

  let ref1: any
  let ref2: any

  const deletePhoneCalendarEvent = async (index: number): Promise<void> => {
    console.log('value ' + calendarEvents[index].title)
    Tiga.System.removePhoneCalendarEvent({ context, eventKey: String(calendarEvents[index].key) })
      .then((res: any) => {
        setCalendarEvents((prevEvents) => prevEvents.filter((event, i) => i !== index))
        Taro.showToast({
          context,
          title: '删除成功',
          duration: 1500,
        })
      })
      .catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason ? e.reason : '',
          title: '删除失败',
          showCancel: false,
        })
      })
  }

  const getPhoneCalendarEvent = async (index: number): Promise<void> => {
    console.log('value ' + calendarEvents[index].title)
    Tiga.System.getPhoneCalendarEvent({ context, eventKey: String(calendarEvents[index].key) })
      .then((res: any) => {
        Taro.showModal({
          context,
          content: JSON.stringify(res, null, 2).substring(1, JSON.stringify(res).length - 1),
          title: '日历事件信息',
          showCancel: false,
        })
      })
      .catch((e: any) => {
        Taro.showModal({
          context,
          content: e.reason ? e.reason : '',
          title: '删除失败',
          showCancel: false,
        })
      })
  }

  return (
    <>
      <DemoBlock label='向系统日历增加事件' pure>
        <Form ref={formRef} align='between'>
          <FormItem
            required
            label='标题'
            prop='title'
            placeholder='请输入标题'
            value={formStateBasic.title}
            onChange={(title) => setFormStateBasic({ title })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  if (value) {
                    callback() // 校验通过必传
                  } else {
                    callback('请补全标题')
                  }
                },
              },
            ]}></FormItem>
          <FormItem
            label='描述'
            prop='description'
            placeholder='请输入事件描述'
            value={formStateBasic.description}
            onChange={(description) => setFormStateBasic({ description })}></FormItem>
          <FormItem
            label='地点'
            prop='location'
            placeholder='请输入事件地点'
            value={formStateBasic.location}
            onChange={(location) => setFormStateBasic({ location })}></FormItem>
          <FormItem
            required
            label='开始时间'
            prop='startTime'
            placeholder='YYYY-MM-DD HH:mm'
            value={formStateBasic.startTime}
            onChange={(startTime) => setFormStateBasic({ startTime })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  const startTime = timeStamp(value)
                  if (startTime) {
                    callback()
                  } else {
                    callback('时间格式 YYYY-MM-DD HH:mm')
                  }
                },
              },
            ]}></FormItem>
          <FormItem
            required
            label='结束时间'
            prop='startTime'
            placeholder='YYYY-MM-DD HH:mm'
            value={formStateBasic.endTime}
            onChange={(endTime) => setFormStateBasic({ endTime })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  const endTime = timeStamp(value)
                  if (endTime) {
                    callback()
                  } else {
                    callback('时间格式 YYYY-MM-DD HH:mm')
                  }
                },
              },
            ]}></FormItem>

          <FormItem
            label='是否全天事件'
            prop='allDay'
            arrow={
              <Toggle
                active={formStateBasic.allDay}
                controls={false}
                onChange={(allDay) => setFormStateBasic({ allDay })}
              />
            }></FormItem>
          <FormItem
            label='是否需要提醒'
            prop='alarm'
            arrow={
              <Toggle
                active={formStateBasic.alarm}
                controls={false}
                onChange={(alarm) => setFormStateBasic({ alarm })}
              />
            }></FormItem>
          <FormItem
            label='提醒提前量'
            prop='alarmOffset'
            placeholder='提醒提前量，单位秒'
            value={formStateBasic.alarmOffset}
            onChange={(value) => setFormStateBasic({ alarmOffset: value })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  const alarmOffset = Number(value)
                  if (!Number.isNaN(alarmOffset)) {
                    callback()
                  } else {
                    callback('填写数字类型提醒提前量，单位秒')
                  }
                },
              },
            ]}></FormItem>

          <FormItem
            label='是否设置重复事件'
            prop='repeat'
            arrow={
              <Toggle
                active={formStateBasic.repeat}
                controls={false}
                onChange={(repeat) => setFormStateBasic({ repeat })}
              />
            }></FormItem>
          <FormItem
            label='重复周期 day/week/month/year'
            prop='repeatInterval'
            placeholder='请输入事件重复周期'
            value={formStateBasic.repeatInterval}
            onChange={(repeatInterval) => setFormStateBasic({ repeatInterval })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  if (
                    value === 'week' ||
                    value === 'day' ||
                    value === 'month' ||
                    value === 'year'
                  ) {
                    callback()
                  } else {
                    callback('重复周期 day/week/month/year')
                  }
                },
              },
            ]}></FormItem>
          <FormItem
            label='重复周期结束时间'
            prop='repeatEndTime'
            placeholder='YYYY-MM-DD HH:mm'
            value={formStateBasic.repeatEndTime}
            onChange={(repeatEndTime) => setFormStateBasic({ repeatEndTime })}
            rules={[
              {
                validator: (rule, value, callback) => {
                  if (!value) {
                    callback()
                  }
                  const repeatEndTime = timeStamp(value)
                  if (repeatEndTime) {
                    callback()
                  } else {
                    callback('时间格式 YYYY-MM-DD HH:mm')
                  }
                },
              },
            ]}></FormItem>
          <Button
            style={{ margin: 8, border: 1 }}
            onClick={async () => {
              const res = await formRef.current.validate()
              if (res) {
                const params = {
                  title: formStateBasic.title,
                  description: formStateBasic.description,
                  location: formStateBasic.location,
                  startTime: timeStamp(formStateBasic.startTime),
                  endTime: String(timeStamp(formStateBasic.endTime)),
                  allDay: formStateBasic.allDay,
                  alarm: formStateBasic.alarm,
                  alarmOffset: Number(formStateBasic.alarmOffset),
                  repeat: formStateBasic.repeat,
                  repeatInterval: formStateBasic.repeatInterval,
                  repeatEndTime: timeStamp(formStateBasic.repeatEndTime),
                  context,
                }
                console.log(
                  'title:' +
                    params.title +
                    '\ndescription:' +
                    params.description +
                    '\nlocation:' +
                    params.location +
                    '\nstartTime:' +
                    params.startTime +
                    '\nendTime:' +
                    params.endTime +
                    '\nallDay:' +
                    params.allDay +
                    '\nalarm:' +
                    params.alarm +
                    '\nalarmOffset:' +
                    params.alarmOffset +
                    '\nrepeat:' +
                    params.repeat +
                    '\nrepeatEndTime:' +
                    params.repeatEndTime +
                    '\nrepeatInterval:' +
                    params.repeatInterval
                )

                Taro.addPhoneCalendar(params)
                  .then((res: any) => {
                    setCalendarEvents((prevEvents) => [
                      prevEvents,
                      { title: params.title, key: res.eventKey },
                    ])
                    Taro.showToast({
                      title: '添加成功',
                      mask: false,
                      context,
                      duration: 1500,
                    })
                  })
                  .catch((e: any) => {
                    console.log('error ' + e.errMsg)
                    Taro.showModal({
                      context,
                      content: e.errMsg ? e.errMsg : '',
                      title: '添加失败',
                      showCancel: false,
                    })
                  })
              }
            }}>
            增加日历事件
          </Button>
        </Form>
      </DemoBlock>
      <DemoBlock label='删除日历事件' pure>
        <Button style={{ margin: 8, border: 1 }} onClick={() => ref1.show()}>
          删除日历事件
        </Button>
        <Picker
          title={'请选择事件'}
          ref={(ref: any) => (ref1 = ref)}
          value={10}
          mode='selector'
          range={calendarEvents.map((event) => event.title)}
          onConfirm={deletePhoneCalendarEvent}
        />
      </DemoBlock>

      <DemoBlock label='获取日历事件' pure>
        <Button style={{ margin: 8 }} onClick={() => ref2.show()}>
          获取日历事件
        </Button>
        <Picker
          title={'请选择事件'}
          ref={(ref: any) => (ref2 = ref)}
          value={10}
          mode='selector'
          range={calendarEvents.map((event) => event.title)}
          onConfirm={getPhoneCalendarEvent}
        />
      </DemoBlock>
    </>
  )
}

export default CalendarDemoBlock
