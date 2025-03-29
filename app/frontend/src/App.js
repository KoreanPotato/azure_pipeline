import React, { useState } from "react";
import axios from "axios";
import "./App.css"; 

function App() {
    const [apiUrl, setApiUrl] = useState("http://localhost:3001/api");
    const [name, setName] = useState("");
    const [response, setResponse] = useState("");

    const sendRequest = async () => {
        try {
            const res = await axios.post(apiUrl, { name });
            setResponse(res.data.message);
        } catch (error) {
            setResponse("Error: " + error.message);
        }
    };

    return (
        <div className="container">
            <div className="inputGroup">
                <input
                    type="text"
                    value={apiUrl}
                    onChange={(e) => setApiUrl(e.target.value)}
                    className="input"
                    placeholder="API endpoint"
                />
                <span className="label">API endpoint</span>
            </div>

            <div className="inputGroup">
                <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="input"
                    placeholder="Your name"
                />
                <span className="label">Your name</span>
            </div>

            <button className="button" onClick={sendRequest}>Submit</button>

            <div className="responseContainer">
                <span className="responseLabel">Server response</span>
                <textarea
                    value={response}
                    readOnly
                    className="responseBox"
                />
            </div>
        </div>
    );
}

export default App;
