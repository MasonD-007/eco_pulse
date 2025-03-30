import React from 'react';
import Head from 'next/head';

const Calculator: React.FC = () => {
  return (
    <div style={{ margin: 0, padding: 0, textAlign: 'center', fontFamily: 'Arial, sans-serif', backgroundColor: '#e8f5e9' }}>
      {/* Head for setting page title and meta tags */}
      <Head>
        <title>Dashboard</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      </Head>
      
      <iframe
        src="https://sustraxmx-offline.vercel.app/dashboard"
        title="Dashboard"
        style={{ width: '100%', height: '100vh', border: 'none' }}
      />
    </div>
  );
};

export default Calculator;
