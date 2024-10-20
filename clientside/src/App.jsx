import React from 'react'
import {Routes , Route} from 'react-router-dom';
import Dashboard from './pages/Employee'
import Signin from './pages/Signin'
import Signup from './pages/Signup'
import './index.css'
import Admin from './pages/Admin';



const App = () => {
  return (
    <>
    <Routes>
    <Route path="/" element={<Signup />} />
   <Route path="/employee" element={<Dashboard />} />
   <Route path="/admin" element={<Admin />} />
 
   <Route path="/signin" element={<Signin />} />
   <Route path="/signup" element={<Signup />} />

    </Routes>
    </>
  )
}

export default App