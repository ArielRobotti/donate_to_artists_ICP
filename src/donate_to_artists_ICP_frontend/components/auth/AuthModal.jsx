import React, { useEffect, useState } from "react"
import { IoMdClose } from "react-icons/io"
import FormInput from "../common/FormInput"
import { useCanister, useConnect } from "@connect2ic/react"
import { useAppStore } from "/frontend/store/store"

const AuthModal = () => {
  const [backend] = useCanister("backend")
  const { isConnected } = useConnect()

  const [email, setEmail] = useState("")
  const [firstName, setFirstName] = useState("")
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState("")
  const { setUserInfo } = useAppStore()

  const signup = async (email, firstName) => {
    setLoading(true)
    const res = await backend.signUp(firstName, [email], [])
    if (res) {
      console.log("res is")
      console.log(res)
      setUserInfo(res.ok)
      setIsAuthModalOpen(false)
    } else {
      setError("Could not register. Try again.")
    }
    setLoading(false)
  }

  const checkUser = async () => {
    const res = await backend.getMiUser()
    console.log("USer is: ", res)
    if (res?.length > 0) {
      setUserInfo(res[0])
      return true
    }
    return false
  }

  const fetchUser = async () => {
    const data = await checkUser()
    if (!data) {
      setIsAuthModalOpen(true)
    } else {
      setIsAuthModalOpen(false)
    }
  }

  const handleSignup = async (e) => {
    e.preventDefault()
    if (email && firstName) {
      const data = await signup(email, firstName)
    }
  }

  useEffect(() => {
    if (isConnected) {
      fetchUser()
    }
  }, [isConnected])

  return (
    <>
      {isAuthModalOpen && (
        <div className="relative z-50 text-black">
          <div className="fixed inset-0 bg-[rgb(25,33,77,0.46)] transition-opacity">
            <div className="fixed inset-0 z-10 overflow-y-auto">
              <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                <div className="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                  <div className="bg-white pb-4 pt-5">
                    <div className="border-b border-b-gray-200 flex items-center justify-center relative pb-5">
                      <span
                        className="absolute left-5 cursor-pointer text-lg"
                        onClick={() => setIsAuthModalOpen(false)}
                      >
                        <IoMdClose></IoMdClose>
                      </span>
                      <span>It's great having you here</span>
                    </div>
                    <div className="p-5">
                      <h3 className="text-xl pb-5">Welcome to your ICP Hub</h3>
                      <div>
                        <form
                          onSubmit={handleSignup}
                          className="flex gap-3 flex-col"
                        >
                          <FormInput
                            name="firstName"
                            placeholder="Your name"
                            value={firstName}
                            setValue={setFirstName}
                          ></FormInput>
                          <FormInput
                            name="email"
                            type="email"
                            placeholder="Your email"
                            value={email}
                            setValue={setEmail}
                          ></FormInput>
                          <button
                            className="bg-indigo-500 py-3 mt-5 w-full text-white font-medium rounded-md hover:bg-indigo-600"
                            type="submit"
                          >
                            {loading ? "..." : "Register"}
                          </button>
                          {error != "" && (
                            <span className="text-danger">{error}</span>
                          )}
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  )
}

export default AuthModal
