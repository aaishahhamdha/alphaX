import React from 'react'
import {Routes , Route} from 'react-router-dom';
import Dashboard from './pages/Dashboard'
import Signin from './pages/Signin'
import Signup from './pages/Signup'
import Header from './components/Header';

const App = () => {
  return (
    <>
    <Header/>
    <Routes>

   <Route path="/dashboard" element={<Dashboard />} />
 
   <Route path="/signin" element={<Signin />} />
   <Route path="/signup" element={<Signup />} />

    </Routes>
    </>
  )
}

export default App