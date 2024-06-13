export namespace Promises {
  export const STATE = {
    PENDING: 'pending',
    FULFILLED: 'fulfilled',
    REJECTED: 'rejected',
  }

  export function decideState(promise) {
    const t = {}
    return Promise.race([promise, t])
      .then((v) => (v === t ? STATE.PENDING : STATE.FULFILLED))
      .catch(() => STATE.REJECTED)
  }
}
