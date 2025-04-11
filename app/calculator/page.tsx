'use client'; // This tells Next.js this is a Client Component

import React from 'react';
import Head from 'next/head';
import { Button } from '@/components/ui/button'; // Assuming you're using the Button component from your library

import { useRouter } from 'next/navigation'; // Importing useRouter from next/navigation
const Calculator: React.FC = () => {
  const router = useRouter();
  const handleSubmit = () => {
    router.push('/output');
  };

  return (
    <div style={{ margin: 0, padding: 0, textAlign: 'center', fontFamily: 'Arial, sans-serif', backgroundColor: '#e8f5e9', position: 'relative' }}>
      {/* Head for setting page title and meta tags */}
      <Head>
        <title>Dashboard</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      </Head>

      {/* Action Button */}
      <div style={{ position: 'absolute', top: '20px', right: '20px' }}>
        <Button
          onClick={handleSubmit}
          className="bg-green-600 hover:bg-green-700 text-white"
        >
          Submit data
        </Button>
      </div>

      <iframe
        src="https://sustraxmx-offline.vercel.app/dashboard"
        title="Dashboard"
        style={{ width: '100%', height: '100vh', border: 'none' }}
      />
    </div>
  );
};

export default Calculator;
