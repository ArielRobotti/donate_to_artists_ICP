import React, { useEffect } from "react";
import { createClient } from "@connect2ic/core";
import { InternetIdentity } from "@connect2ic/core/providers";
import { Connect2ICProvider, useCanister, useConnect } from "@connect2ic/react";
import "@connect2ic/core/style.css";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
// import * as back from "../.dfx/local/canisters/back"
import * as back from "../../declarations/back/back.did";
// import Navbar from "./components/layout/Navbar"
// import Footer from "./components/layout/Footer"
// import { Home } from "./pages/home"
// import { New } from "./pages/tutorials/new"
// import Incoming from "./pages/tutorials/incoming"
// import Approved from "./pages/tutorials/approved"
// import Details from "./pages/tutorials/details"
function App() {
    const { isConnected, principal } = useConnect();
    const [back] = useCanister("back");
    const [user, setUser] = useState({});
    const [admin, setAdmin] = useState(false);
    const rightToVote = async () => {
        let isAdmin = await back.iamAdmin();
        console.log("Is admin? ", isAdmin);
        return isAdmin ? true : false;
    };
    useEffect(() => {
        const fetchData = async () => {
            if (isConnected) {
                setUser(await back.getMyUser());
                setAdmin(await back.iAmAdmin);
            }
        };
        fetchData();
    }, [isConnected, principal]);
    return (React.createElement(Router, null,
        React.createElement("div", { className: "App dark:bg-slate-800 dark:text-white" },
            React.createElement(Navbar, null),
            React.createElement(Routes, null,
                React.createElement(Route, { path: "/", Component: Home }),
                React.createElement(Route, { path: "/pages/landingpage", Component: New }),
                React.createElement(Route, { path: "/pages", Component: Approved }),
                React.createElement(Route, { path: "/pages", Component: Details }),
                React.createElement(Route, { path: "/pages/admin", element: admin ? React.createElement(IncomingArtist, null) : React.createElement(Navigate, { to: "/" }) }),
                React.createElement(Route, { path: "/tutorials/new", element: isConnected ? React.createElement(New, null) : React.createElement(Navigate, { to: "/" }) })),
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
