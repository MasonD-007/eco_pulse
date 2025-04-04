"use client";

import { useState } from "react";
import { db } from "@/lib/firebase"; // adjust the import path as needed
import { collection, addDoc } from "firebase/firestore";

export default function CarbonInputPage() {
  const [status, setStatus] = useState("");

  const handleSave = async () => {
    try {
      const docRef = await addDoc(collection(db, "users"), {
        name: '',
        footprint: 30,
        createdAt: new Date(),
      });
      setStatus(`Document written with ID: ${docRef.id}`);
    } catch (error) {
      console.error("Error adding document: ", error);
      setStatus("Error saving document.");
    }
  };

  return (
    <div className="p-4">
        <input type='number' step='0.01' id='footprint' name='footprint' required placeholder="Type your carbon footprint here" maxLength={10}></input>
      <button
        onClick={handleSave}
        className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
      >
        Save Data
      </button>
      {status && <p className="mt-2 text-sm text-gray-700">{status}</p>}
    </div>
  );
}

