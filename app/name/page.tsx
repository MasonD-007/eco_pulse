'use client';

import React, { useState } from 'react';
import Head from 'next/head';
import Link from 'next/link';
import { Button } from '@/components/ui/button';

const Name: React.FC = () => {
  const [name, setName] = useState('');

  return (
    <div style={{ margin: 0, padding: '20px', textAlign: 'center', fontFamily: 'Arial, sans-serif', backgroundColor: '#e8f5e9' }}>
      {/* Head for setting page title and meta tags */}
      <Head>
        <title>Enter Name</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="https://fonts.googleapis.com/css2?family=Libre+Baskerville:wght@400;700&display=swap" rel="stylesheet" />
      </Head>

      <h1 style={{ fontSize: '2.5rem', fontWeight: 'bold', fontFamily: "'Libre Baskerville', serif" }}>
        Enter Your Name
      </h1>
      <input
        type="text"
        placeholder="Enter your name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        style={{
          padding: '10px',
          fontSize: '16px',
          marginBottom: '10px',
          width: '100%',
          maxWidth: '300px',
        }}
      />
      <br />
      <Link href="/calculator" passHref>
        <Button className="bg-green-600 hover:bg-green-700 mt-4">Calculate</Button>
      </Link>
    </div>
  );
};

export default Name;

