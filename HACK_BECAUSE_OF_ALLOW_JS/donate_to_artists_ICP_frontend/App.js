import { useEffect, useState } from "react";
import { createClient } from "@connect2ic/core";
import { InternetIdentity } from "@connect2ic/core/providers";
import { Connect2ICProvider, useCanister, useConnect } from "@connect2ic/react";
import "@connect2ic/core/style.css";
import { BrowserRouter as Router } from "react-router-dom";
// import * as back from "../.dfx/local/canisters/back"
import * as back from "../declarations/back";
import Footer from "./components/layout/Footer";
import * as React from "react";
function App() {
    const { isConnected, principal } = useConnect();
    const [back] = useCanister("back");
    const [usuario, setUser] = useState();
    const [admin, setAdmin] = useState(false);
    useEffect(() => {
        const fetchData = async () => {
            if (isConnected) {
                setUser(await back.getMyUser());
                setAdmin(await back.iAmAdmin());
                console.log(admin);
                console.log(usuario);
            }
        };
        fetchData();
    }, [isConnected, principal]);
    return (React.createElement(Router, null,
        React.createElement("div", { className: "App dark:bg-slate-800 dark:text-white" },
            React.createElement(Footer, null))));
}
const network = process.env.DFX_NETWORK || (process.env.NODE_ENV === "production" ? "ic" : "local");
const internetIdentityUrl = network === "local" ? "http://localhost:4943/?canisterId=rdmx6-jaaaa-aaaaa-aaadq-cai" : "https://identity.ic0.app";
const client = createClient({
    canisters: {
        back,
    },
    providers: [
        new InternetIdentity({
            dev: true,
            // The url for the providers frontend
            providerUrl: internetIdentityUrl,
            // "http://localhost:4943/?canisterId=rdmx6-jaaaa-aaaaa-aaadq-cai",
        }),
    ],
    globalProviderConfig: {
        // dev: import.meta.env.DEV,
        dev: true,
    },
});
export default () => (React.createElement(Connect2ICProvider, { client: client },
    React.createElement(App, null)));
