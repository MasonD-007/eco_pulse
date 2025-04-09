"use client";

import { useState } from "react";
import { db } from "@/lib/firebase"; // adjust the import path as needed
import { collection, addDoc } from "firebase/firestore";

export default function CarbonInputPage() {
  const [status, setStatus] = useState("");
  const [footprint, setFootprint] = useState("");
  const [name, setName] = useState("");

  const handleSave = async () => {
    if (!name.trim()) {
      setName("Anonymous");
    }
    if (!footprint) {
      setStatus("Please enter your carbon footprint");
      return;
    }

    try {
      console.log("Saving data...");
      console.log("name: " + name.trim());
      console.log("footprint: " + footprint);
      await addDoc(collection(db, "users"), {
        name: name.trim(),
        footprint: parseFloat(footprint),
        createdAt: new Date(),
      });
      setStatus(`Successfully saved your carbon footprint!`);
      // Clear the form after successful submission
      setName("");
      setFootprint("");
    } catch (error) {
      console.error("Error adding document: ", error);
      setStatus("Error saving document.");
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Carbon Footprint Tracker</h1>
          <p className="text-gray-600">Record and monitor your carbon impact</p>
        </div>

        <div className="bg-white shadow rounded-lg p-6 space-y-6">
          <div className="space-y-2">
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">
              Your Name
            </label>
            <input
              id="name"
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Enter your name or be anonymous"
              className="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
            />
          </div>

          <div className="space-y-2">
            <label htmlFor="footprint" className="block text-sm font-medium text-gray-700">
              Carbon Footprint (tons CO2/year)
            </label>
            <input
              id="footprint"
              type="number"
              step="0.01"
              value={footprint}
              onChange={(e) => setFootprint(e.target.value)}
              placeholder="Enter your carbon footprint here"
              className="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
              required
            />
          </div>

          <button
            onClick={handleSave}
            className="w-full bg-green-600 text-white px-4 py-3 rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors"

          >
            Save Carbon Footprint
          </button>

          {status && (
            <div className={`mt-4 p-3 rounded-md ${status.includes("Error")
                ? "bg-red-50 text-red-700"
                : "bg-green-50 text-green-700"
              }`}>
              {status}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
