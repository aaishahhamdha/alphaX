import React from 'react'
import TextField from '@mui/material/TextField';
import SubmitButton from './SubmitButton';
import  "../index.css";

function SignupForm() {
  return (
    <form className='formCss'>
      <h2 className='headingForm'>
        SignUp
      </h2>
      <TextField
        label="Name"
        variant="outlined"
        fullWidth
        margin="normal"
      />
      <TextField
        label="Username"
        variant="outlined"
        fullWidth
        margin="normal"
      />
      <TextField
        label="Password"
        variant="outlined"
        fullWidth
        margin="normal"
      />
      <SubmitButton buttonTitle="SignUp"></SubmitButton>
    </form>
  )
}

export default SignupForm