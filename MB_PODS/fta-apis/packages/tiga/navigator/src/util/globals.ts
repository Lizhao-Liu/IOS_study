export namespace GlobalThis {
  export function set(key: string, value: any) {
    globalThis[key] = value
  }

  export function get(key: string) {
    return globalThis[key]
  }
}
