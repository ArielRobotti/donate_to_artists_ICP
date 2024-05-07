import React from "react"
import className from "classnames"

const Button = ({
  children,
  primary,
  secondary,
  success,
  warning,
  danger,
  outline,
  rounded,
  ...rest
}) => {
  const classes = className(
    rest.className,
    "rounded-full px-3.5 py-2.5 font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600",
    {
      "bg-indigo-600 text-white": primary,
      "bg-gray-900 text-white": secondary,
      "bg-green-500 text-white": success,
      "bg-yellow-400 text-white": warning,
      "bg-red-500 text-white": danger,
      "bg-transparent border-2 border-indigo-600 tex-indigo-600": outline,
      "text-blue-500": outline && primary,
      "text-gray-900": outline && secondary,
      "text-green-500": outline && success,
      "text-yellow-400": outline && warning,
      "text-red-500": outline && danger,
    },
  )

  return (
    <button {...rest} className={classes}>
      {children}
    </button>
  )
}

Button.propTypes = {
  checkVariationValue: ({ primary, secondary, success, warning, danger }) => {
    const count =
      Number(!!primary) +
      Number(!!secondary) +
      Number(!!warning) +
      Number(!!success) +
      Number(!!danger)

    if (count > 1) {
      return new Error(
        "Only one of primary, secondary, success, warning, danger can be true",
      )
    }
  },
}

export default Button
