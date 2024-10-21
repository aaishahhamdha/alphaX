import React, { useState } from 'react';
import { TextField } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import SubmitButton from './SubmitButton';

import "../index.css";

function SignupForm() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState(''); 
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(''); 

  
    if (!name || !email || !password) {
      setError('All fields are required.');
      return;
    }

    const userData = {
      mail: email,
      name: name,
      password: password,
    };

    try {
      const response = await fetch('http://localhost:9090/api/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
      });

      if (!response.ok) {
        throw new Error('Signup failed. Please try again.');
      }

    
      alert('Signup successful!');
    
      navigate('/signin');
    } catch (error) {
      setError(error.message);
    }
  };

  return (
    <form className='formCss' onSubmit={handleSubmit}>
      <h2 className='headingForm'>SignUp</h2>
      {error && <p className='error'>{error}</p>} 
      <TextField
        label="Name"
        variant="outlined"
        fullWidth
        margin="normal"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <TextField
        label="Email" 
        variant="outlined"
        fullWidth
        margin="normal"
        value={email}
        onChange={(e) => setEmail(e.target.value)} 
      />
      <TextField
        label="Password"
        type="password"
        variant="outlined"
        fullWidth
        margin="normal"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <SubmitButton buttonTitle="SignUp" />
    </form>
  );
}

export default SignupForm;
