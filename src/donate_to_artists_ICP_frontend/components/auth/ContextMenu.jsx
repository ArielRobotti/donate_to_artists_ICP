import React, { useRef, useEffect } from "react"
import { useAppStore } from "/frontend/store/store"

const ContextMenu = ({ options, cordinates, setContextMenu }) => {
  const contextMenuRef = useRef(null);
  const { userInfo } = useAppStore();

  const handleClick = (e, callBack) => {
    e.stopPropagation();
    callBack();
  }

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (
        contextMenuRef.current &&
        !contextMenuRef.current.contains(event.target)
      ) {
        setContextMenu(false)
      }
    }

    document.addEventListener("click", handleClickOutside)

    return () => {
      document.removeEventListener("click", handleClickOutside)
    }
  }, [])

  const renderedOptions = options.map(({ name, callBack }) => {
    return (
      <li
        key={name}
        onClick={(e) => handleClick(e, callBack)}
        className="hover:bg-gray-700 pl-5 pr-10 py-2 cursor-pointer"
      >
        <span>{name}</span>
      </li>
    )
  })

  return (
    <div
      ref={contextMenuRef}
      style={{
        boxShadow:
          "0 2px 5px 0 rgba(var(11,20,26),.26),0 2px 10px 0 rgba(11,20,26;),.16)",
        top: cordinates.y,
        left: cordinates.x,
      }}
      className="bg-white dark:bg-neutral-900 shadow-2xl fixed py-5 z-[100] rounded-lg border border-gray-200 dark:border-gray-800"
    >
      <ul>
        <li className="pl-5 pr-10 py-2 mb-2 text-bold text-lg">
          {userInfo ? `Hi, ${userInfo.name}` : "Connect your ICP ID to start"}
          <hr className="mt-2"/>
        </li>
        {renderedOptions}
      </ul>
    </div>
  )
}

export default ContextMenu
