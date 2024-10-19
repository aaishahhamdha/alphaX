import React from 'react'
import './Dashboard.css'
import Calendar from '../Components/Calendar'
import Piechart from '../Components/Piechart'
import Card from '../Components/Card'
import CardSmall from '../Components/CardSmall'
import {Button} from '@mui/material'
import '../index.css'



const Admin = () => {
  return (
    <div className='dashboard'>
      <div className='left admin-left'>
          <div className='col1'>
              <div className='col1-top'>
                 <Card></Card>
              </div>
              <div className='col1-bot'>
                 <Piechart></Piechart>
              </div>
          </div>
          <div className='col2'>
              <CardSmall></CardSmall>
          </div>
      </div>
      <div className='right'>
         <Calendar/>
      </div>
    </div>
  )
}

export default Admin