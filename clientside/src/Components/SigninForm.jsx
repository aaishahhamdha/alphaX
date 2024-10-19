import React from 'react'
import TextField from '@mui/material/TextField';
import SubmitButton from './SubmitButton';
import  "../index.css";


function SigninForm() {
  return (
    <form className='formCss'>
      <h2 className='headingForm'>
        SignIn
      </h2>
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
      <SubmitButton buttonTitle="Login"></SubmitButton>
    </form>
  )
}

export default SigninForm