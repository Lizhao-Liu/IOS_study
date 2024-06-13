import React from 'react'

interface DesignProps {
  src: string
}

export default function Design(props: DesignProps) {
  return (
    <iframe scrolling="no" frameBorder="0" style={{ width: '100%', height: 'calc(100vh - 200px)' }} src={props.src} />
  )
}
