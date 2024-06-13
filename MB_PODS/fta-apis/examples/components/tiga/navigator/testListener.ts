let inited = false

export function init() {
  if (inited) {
    return
  }
  inited = true

  console.log('init called')
  window.addEventListener('popstate', (event) => {
    console.log('got event: popstate', event)
  })

  window.history.pushState = _historyWrap('pushState')
  window.history.replaceState = _historyWrap('replaceState')
}

const _historyWrap = function (type: keyof typeof history) {
  console.log('hook ' + type)
  const orig = window.history[type]
  return function () {
    const rv = orig.apply(window.history, arguments)
    console.log('hook called', type)
    return rv
  }
}
