export function withNavigator<P, S>(
  component: React.ComponentClass<P, S>
): React.ComponentClass<P, S> {
  return component
}

export function initNavigator() {}
