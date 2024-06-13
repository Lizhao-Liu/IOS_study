export namespace GlobalThis {
  export function set(key: string, value: any) {
    window[key] = value
  }

  export function get(key: string) {
    return window[key]
  }
}
