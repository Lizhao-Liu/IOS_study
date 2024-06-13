export function testPromise() {
  wrappedPromise()
    .then((data) => {
      console.log('test', 'fulfilled ' + data)
    })
    .catch((error) => {
      console.log('test', 'failed ' + error)
    })
}

function wrappedPromise() {
  return new Promise((resolve, reject) => {
    originalPromise()
      .then((data) => {
        return reject(data)
      })
      .catch((error) => {
        console.log('wrapped', error)
        reject(error)
      })
  })
}

function originalPromise() {
  return new Promise((resolve, reject) => {
    resolve(1)
  })
}
