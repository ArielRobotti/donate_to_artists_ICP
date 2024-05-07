import React from "react";

const FormInput = ({type="text", value, setValue, placeholder}) => {
  return <input 
    type={type} 
    value={value}
    placeholder={placeholder} 
    onChange={e => setValue(e.target.value)}
    className="border border-gray-300 hover:border-gray-400 focus:outline-none focus:outline-indigo-300 p-3 rounded-md w-full">
    </input>;
};

export default FormInput;