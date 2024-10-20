import React from 'react'
import TextField from '@mui/material/TextField';
import SubmitButton from './SubmitButton';
import Radio from '@mui/material/Radio';
import RadioGroup from '@mui/material/RadioGroup';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormLabel from '@mui/material/FormLabel';
import  "../index.css";

function FormFood() {
  return (
    <form className='formCss'>
      <TextField
        label="FoodName"
        variant="outlined"
        fullWidth
        margin="normal"
      />

      <FormLabel id="demo-controlled-radio-buttons-group">Type</FormLabel>
      <RadioGroup
        aria-labelledby="demo-controlled-radio-buttons-group"
        name="controlled-radio-buttons-group"
      >
        <FormControlLabel value="veg" control={<Radio />} label="Vegeterian" />
        <FormControlLabel value="nonVeg" control={<Radio />} label="Non-Vegetarian" />
        <FormControlLabel value="egg" control={<Radio />} label="Egg" />
      </RadioGroup>

      <FormLabel id="demo-controlled-radio-buttons-group">Time</FormLabel>
      <RadioGroup
        aria-labelledby="demo-controlled-radio-buttons-group"
        name="controlled-radio-buttons-group"
      >
        <FormControlLabel value="Breakfast" control={<Radio />} label="Breakfast" />
        <FormControlLabel value="Lunch" control={<Radio />} label="Lunch" />
        <FormControlLabel value="Dinner" control={<Radio />} label="Dinner" />
      </RadioGroup>
      <SubmitButton buttonTitle="Add Food"></SubmitButton>
    </form>
  )
}

export default FormFood