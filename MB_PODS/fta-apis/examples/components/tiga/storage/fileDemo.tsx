import { Gap, Input, List, ListItem, Text, Textarea, Toggle, scale } from '@fta/components'
import { Button, DemoBlock } from '@fta/components/common/display'
import { useThreshContext } from '@fta/hooks'
import Tiga from '@fta/tiga'
import Taro from '@tarojs/taro'
import React, { useState } from 'react'

function FileDemoBlock() {
  const context = useThreshContext()
  const [sandbox, setSandbox] = useState<Tiga.Storage.SandBoxPathResult>({
    userPath: '',
    tempPath: '',
  })
  const [pathOne, setPathOne] = useState('/test目录3')
  const [pathTwo, setPathTwo] = useState('')
  const [usePathOne, setUsePathOne] = useState(true)
  const [isRecursive, setIsRecursive] = useState(false)

  const [readFileResult, setReadFileResult] = useState('')
  const [readDirResult, setReadDirResult] = useState('')
  const [statResult, setStatResult] = useState('')

  function getCurrentPath(): string {
    if (usePathOne) {
      console.log('pathOne: ', pathOne)
      return sandbox.userPath + pathOne
    }
    console.log('pathTwo: ', pathOne)
    return sandbox.tempPath + pathTwo
  }

  function getPathOne(): string {
    return sandbox.userPath + pathOne
  }

  function getPathTwo(): string {
    return sandbox.userPath + pathTwo
  }

  return (
    <>
      <DemoBlock label='Tiga-文件操作接口' pure>
        <Button
          onClick={() => {
            Tiga.Storage.getSandboxPath({
              context: context,
              success(res) {
                console.log(`getSandboxPath success: ${res.userPath}, ${res.tempPath}`)
                setSandbox(res)
              },
              complete(res) {
                console.log('getSandboxPath complete')
              },
              fail(res) {
                console.log('getSandboxPath fail: ', res)
              },
            })
          }}>
          获取沙盒绝对路径
        </Button>
        <Gap />
        <List hoverless itemStyle={{ paddingTop: scale(21), paddingBottom: scale(21) }}>
          <ListItem title={sandbox.userPath} />
          <ListItem title={sandbox.tempPath} />
        </List>
      </DemoBlock>

      <DemoBlock label='参数设置' pure>
        <Text style={{ paddingLeft: 10 }} size={24} color='#666666'>
          路径path1(srcPath, 相对于用户目录)
        </Text>
        <Input
          className='keyname'
          placeholder='请输入路径path'
          value={pathOne}
          onInput={(evt) => setPathOne?.(evt.detail.value)}
        />
        <Text style={{ paddingLeft: 10 }} size={24} color='#666666'>
          {' '}
          路径path2(destPath, 相对于临时目录):
        </Text>
        <Input
          className='keyname'
          placeholder='请输入路径path'
          value={pathTwo}
          onInput={(evt) => setPathTwo?.(evt.detail.value)}
        />
        <List hoverless itemStyle={{ paddingTop: scale(21), paddingBottom: scale(21) }}>
          <ListItem
            title='开使用path1/关path2 '
            arrow={
              <Toggle
                active={usePathOne}
                controls={false}
                onChange={(enable) => setUsePathOne(enable)}
              />
            }
          />
          <ListItem
            title='是否递归'
            arrow={
              <Toggle
                active={isRecursive}
                controls={false}
                onChange={(enable) => setIsRecursive(enable)}
              />
            }
          />
        </List>
      </DemoBlock>
      <DemoBlock label='文件管理测试' pure>
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.access({
              context: context,
              path: getCurrentPath(),
              success(res) {
                console.log('文件/目录存在: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + '存在',
                })
              },
              fail(result) {
                console.log('文件/目录不存在: ', result)
                Taro.showModal({
                  context: context,
                  content: getCurrentPath() + '不存在',
                })
              },
              complete(res) {
                console.log('文件/目录是否存complete: ', res)
              },
            })
          }}>
          文件/目录是否存在 FileSystemManager.access
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.mkdir({
              context: context,
              dirPath: getCurrentPath(),
              success(res) {
                console.log('创建目录成功: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + '目录 创建成功',
                })
              },
              fail(result) {
                console.log('创建目录目录失败: ', result)
                Taro.showModal({
                  context: context,
                  content: getCurrentPath() + '目录 创建失败' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('创建目录目录complete: ', res)
              },
            })
          }}>
          创建目录 FileSystemManager.mkdir
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.rmdir({
              context: context,
              dirPath: getCurrentPath(),
              recursive: isRecursive,
              success(res) {
                console.log('删除目录成功: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + '目录 删除成功',
                })
              },
              fail(result) {
                console.log('删除目录目录失败: ', result)
                Taro.showModal({
                  context: context,
                  content: getCurrentPath() + '目录 删除失败' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('删除目录目录complete: ', res)
              },
            })
          }}>
          删除目录 FileSystemManager.rmdir
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.readdir({
              context: context,
              dirPath: getCurrentPath(),
              success(res) {
                console.log('读取制定目录文件名成功: ', res)
                setReadDirResult('读取目录成功: ' + JSON.stringify(res))
              },
              fail(result) {
                console.log('读取制定目录文件名失败: ', result)

                setReadDirResult('读取目录失败: ' + JSON.stringify(result))
              },
              complete(res) {
                console.log('读取制定目录文件名complete: ', res)
              },
            })
          }}>
          读取目录文件列表 FileSystemManager.readdir
        </Button>
        <Gap height={8} />
        <Textarea
          disabled={false}
          autoHeight={true}
          value={readDirResult}
          maxLength='9999'
          onChange={() => {}}
        />
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.writeFile({
              context: context,
              filePath: getCurrentPath(),
              data: '测试字符串写入',
              success(res) {
                console.log('写入文件成功: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + '文件 写入成功',
                })
              },
              fail(result) {
                console.log('写入文件失败: ', result)
                Taro.showModal({
                  context: context,
                  content: getCurrentPath() + '文件 写入失败' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('写入文件文件complete: ', res)
              },
            })
          }}>
          写文件 FileSystemManager.writeFile
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.appendFile({
              context: context,
              filePath: getCurrentPath(),
              data: '文件末尾追加字符串',
              success(res) {
                console.log('文件末尾追加内容成功: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + '文件 追加成功',
                })
              },
              fail(result) {
                console.log('写文件末尾追加内容失败: ', result)
                Taro.showModal({
                  context: context,
                  title: getCurrentPath() + '文件 追加失败' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('文件末尾追加内容complete: ', res)
              },
            })
          }}>
          追加文本 FileSystemManager.appendFile
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.readFile({
              context: context,
              filePath: getCurrentPath(),
              success(res) {
                console.log('读取文件成功: ', res)
                setReadFileResult('读取文件内容成功: ' + JSON.stringify(res))
              },
              fail(result) {
                console.log('读取文件失败: ', result)
                setReadFileResult('读取文件内容失败' + JSON.stringify(result))
              },
              complete(res) {
                console.log('读取文件complete: ', res)
              },
            })
          }}>
          读取文件 FileSystemManager.readFile
        </Button>
        <Gap height={8} />
        <Textarea
          disabled={false}
          autoHeight={true}
          value={readFileResult}
          maxLength='99'
          onChange={() => {}}
        />
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.unlink({
              context: context,
              filePath: getCurrentPath(),
              success(res) {
                console.log('删除文件成功: ', res)
                Taro.showToast({
                  context: context,
                  title: getCurrentPath() + ' 删除文件成功',
                })
              },
              fail(result) {
                console.log('删除文件失败: ', result)
                Taro.showModal({
                  context: context,
                  content: getCurrentPath() + ' 删除文件失败',
                })
              },
              complete(res) {
                console.log('删除文件complete: ', res)
              },
            })
          }}>
          删除文件 FileSystemManager.unlink
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.copyFile({
              context: context,
              srcPath: getPathOne(),
              destPath: getPathTwo(),
              success(res) {
                console.log('copy文件成功: ', res)
                Taro.showToast({
                  context: context,
                  title: '拷贝文件成功',
                })
              },
              fail(result) {
                console.log('copy文件失败: ', result)
                Taro.showModal({
                  context: context,
                  content: '拷贝文件失败:' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('copy文件complete: ', res)
              },
            })
          }}>
          拷贝文件 FileSystemManager.copyFile
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.rename({
              context: context,
              oldPath: getPathOne(),
              newPath: getPathTwo(),
              success(res) {
                console.log('移动文件成功: ', res)
                Taro.showToast({
                  context: context,
                  title: '重命名/移动文件成功',
                })
              },
              fail(result) {
                console.log('移动文件失败: ', result)
                Taro.showModal({
                  context: context,
                  content: '重命名/移动文件失败:' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('移动文件complete: ', res)
              },
            })
          }}>
          移动文件/目录 FileSystemManager.rename
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.saveFile({
              context: context,
              tempFilePath: getPathOne(),
              filePath: getPathTwo(),
              success(res) {
                console.log('保存临时文件成功: ', res)
                Taro.showToast({
                  context: context,
                  title: '保存文件成功',
                })
              },
              fail(result) {
                console.log('保存临时文件失败: ', result)
                Taro.showModal({
                  context: context,
                  content: '保存文件失败:' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('保存临时文件complete: ', res)
              },
            })
          }}>
          保存文件 FileSystemManager.saveFile
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.getFileInfo({
              context: context,
              filePath: getCurrentPath(),
              success(res) {
                console.log('getFileInfo成功: ', res)
                Taro.showToast({
                  context: context,
                  title: 'fileInfo:' + JSON.stringify(res),
                })
              },
              fail(result) {
                console.log('getFileInfo失败: ', result)
                Taro.showModal({
                  context: context,
                  content: 'getFileInfo failed: ' + JSON.stringify(result),
                })
              },
              complete(res) {
                console.log('getFileInfocomplete: ', res)
              },
            })
          }}>
          获取文件信息 FileSystemManager.getFileInfo
        </Button>
        <Gap />
        <Button
          onClick={() => {
            const fileManager = Taro.getFileSystemManager()
            fileManager.stat({
              context: context,
              path: getCurrentPath(),
              recursive: isRecursive,
              success(res) {
                console.log('获取stat对象成功: ', res)
                setStatResult('获取stat对象成功: ' + JSON.stringify(res))
              },
              fail(result) {
                console.log('获取stat对象失败: ', result)
                setStatResult('获取stat对象失败: ' + JSON.stringify(result))
              },
              complete(res) {
                console.log('获取stat对象complete: ', res)
              },
            })
          }}>
          获取文件stat对象 FileSystemManager.stat
        </Button>
        <Gap height={8} />
        <Textarea
          disabled={false}
          autoHeight={true}
          value={statResult}
          maxLength='99'
          onChange={() => {}}
        />
      </DemoBlock>
    </>
  )
}

export default FileDemoBlock
