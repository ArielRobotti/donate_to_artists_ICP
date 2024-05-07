


import  { useEffect, useState } from "react";

/*
 * Connect2ic provides essential utilities for IC app development
 */
import { Actor, HttpAgent } from '@dfinity/agent';
import { createClient } from "@connect2ic/core"
import { InternetIdentity } from "@connect2ic/core/providers"
import { Connect2ICProvider, useCanister, useConnect } from "@connect2ic/react"
import "@connect2ic/core/style.css"

import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom"

// import * as back from "../.dfx/local/canisters/back"
import * as back from "../declarations/back"


import Footer from "./components/layout/Footer"
import * as React from "react";

interface Principal {
  _arr : Uint8Array;
  _isPrincipal: boolean;
}

interface Usuario {
  principal: Principal;
  uid: number;
  nick: string;
  email: string;
  foto?: Blob | null; // La foto puede ser Blob o null
}


function App() {
  const { isConnected, principal} = useConnect();
  const [back] = useCanister("back");

  const [usuario, setUser] = useState<Usuario>();
  const [admin, setAdmin] = useState(false);
  
  useEffect(() => {
    const fetchData = async () => {
      if (isConnected) {
        setUser(await back.getMyUser() as Usuario);
        setAdmin(await back.iAmAdmin() as boolean);
        console.log(admin);
        console.log(usuario)
      }
    };
    fetchData();
  }, [isConnected, principal]);

  return (
    <Router>
      <div className="App dark:bg-slate-800 dark:text-white">
        <Footer></Footer>
      </div>
    </Router>
  )
}
declare let process : {
  env: {
    DFX_NETWORK: string
    NODE_ENV: string
  }
}
const network = process.env.DFX_NETWORK || (process.env.NODE_ENV === "production" ? "ic" : "local");
const internetIdentityUrl = network === "local" ? "http://localhost:4943/?canisterId=rdmx6-jaaaa-aaaaa-aaadq-cai" : "https://identity.ic0.app"

const client = createClient({
  canisters: {
    back,
  },
  providers: [
    new InternetIdentity({
      dev: true,
      // The url for the providers frontend
      providerUrl:
      internetIdentityUrl,
        // "http://localhost:4943/?canisterId=rdmx6-jaaaa-aaaaa-aaadq-cai",
    }),
  ],
  globalProviderConfig: {
    // dev: import.meta.env.DEV,
    dev: true,
  },
})

export default () => (
  <Connect2ICProvider client={client}>
    <App />
  </Connect2ICProvider>
)
