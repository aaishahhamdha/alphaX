import React from 'react'
import './Dashboard.css'
import Calendar from '../Components/Calendar'
import Selector from '../Components/Selector'
import '../index.css'


const Dashboard = () => {
  return (
    <div className='dashboard' style={{backgroundColor: 'var(--background-color)'}}>
      <div className='left' style={{backgroundColor: 'var(--background-color)'}}>
          <Selector></Selector>
      </div>
      <div className='right' style={{backgroundColor: 'var(--background-color2)'}}>
         <Calendar/>
      </div>
    </div>
  )
}

export default Dashboard