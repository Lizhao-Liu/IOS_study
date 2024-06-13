function isiOS(): boolean {
  const ua = navigator.userAgent
  return !!ua.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)
}

function isAndroid(): boolean {
  if (/Android/i.test(navigator.userAgent)) {
    return true
  }
  return false
}

export { isiOS, isAndroid }
