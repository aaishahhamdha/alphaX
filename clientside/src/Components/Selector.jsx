import React, { useState } from 'react';
import Box from '@mui/material/Box';
import Tab from '@mui/material/Tab';
import TabContext from '@mui/lab/TabContext';
import TabList from '@mui/lab/TabList';
import TabPanel from '@mui/lab/TabPanel';
import { Typography, Button, List, ListItem, ListItemText } from '@mui/material';
import empty from './Images/empty.png'
import '../index.css'

export default function LabTabs() {
  const main = ["one", "two", "three", "four"];
  const sub = ["Veg", "Non-Veg"];
  const veg = ["v1", "v2", "v3", "v4"];
  const nv = ["nv1", "nv2", "nv3", "nv4"];

  const [mainValue, setMainValue] = useState('-1'); // No main tab selected by default
  const [subValue, setSubValue] = useState('-1');   // No sub-tab selected by default
  const [selectedItems, setSelectedItems] = useState([]); // Track selected items

  const handleMainChange = (event, newValue) => {
    setMainValue(newValue);
    setSubValue('-1'); // Reset sub-tab to '-1' when switching main tab
  };

  const handleSubChange = (event, newValue) => {
    setSubValue(newValue);
  };

  const handleItemToggle = (item) => {
    setSelectedItems((prevItems) => {
      if (prevItems.includes(item)) {
        return prevItems.filter((i) => i !== item);
      } else {
        return [...prevItems, item];
      }
    });
  };

  const handleSubmit = () => {
    alert("Selected Items: " + selectedItems.join(', '));
    // Handle submit logic here, such as sending data to an API
  };

  return (
    <Box sx={{ width: '100%', typography: 'body1'}}>
      <TabContext value={mainValue}>
        <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
          <TabList onChange={handleMainChange} aria-label="Main Tabs">
            {main.map((item, index) => (
              <Tab key={index} label={item} value={String(index)} sx={{
                color: 'var(--text-primary)',
                fontSize: 'var(--font-size-normal)',
                fontWeight : 'bold',
                padding: '1%',
                }}/>
            ))}
          </TabList>
        </Box>
        
        {mainValue === '-1' ? (
          <div style={{display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
          <img src={empty}/>
          </div>
        ) : (
          main.map((item, index) => (
            <TabPanel key={index} value={String(index)} sx={{padding: '0px'}} className='effect'>
              <TabContext value={subValue}>
                <Box sx={{ borderBottom: 1, borderColor: 'divider', mt: 2, backgroundColor: 'var(--text-primary)'}}>
                  <TabList onChange={handleSubChange} aria-label="Sub Tabs">
                    {sub.map((subItem, subIndex) => (
                      <Tab key={subIndex} label={subItem} value={String(subIndex)} sx={{color: 'var(--background-color)'}}/>
                    ))}
                  </TabList>
                </Box>

                {subValue === '-1' ? (
                  <div style={{display: 'flex', justifyContent: 'center', alignItems: 'center' , padding: '3%'}}>
                  <Typography>Select Item</Typography>
                  </div>
                ) : (
                  <>
                    <TabPanel value="0">
                      {veg.map((vegItem, vegIndex) => (
                        <Typography 
                          key={vegIndex} 
                          onClick={() => handleItemToggle(vegItem)}
                          sx={{ 
                            cursor: 'pointer', 
                            backgroundColor: selectedItems.includes(vegItem) ? '#ddd' : 'transparent',
                            p: 1,
                            borderRadius: '4px',
                            mb: 1,
                          }}
                        >
                          {vegItem}
                        </Typography>
                      ))}
                    </TabPanel>
                    
                    <TabPanel value="1">
                      {nv.map((nvItem, nvIndex) => (
                        <Typography 
                          key={nvIndex} 
                          onClick={() => handleItemToggle(nvItem)}
                          sx={{ 
                            cursor: 'pointer', 
                            backgroundColor: selectedItems.includes(nvItem) ? '#ddd' : 'transparent',
                            p: 1,
                            borderRadius: '4px',
                            mb: 1,
                          }}
                        >
                          {nvItem}
                        </Typography>
                      ))}
                    </TabPanel>
                  </>
                )}
              </TabContext>
            </TabPanel>
          ))
        )}
      </TabContext>

      {/* Selected items box */}
      <Box sx={{ mt: 3, p: 2, border: '1px solid #ddd', borderRadius: '4px', backgroundColor: 'var(--green)'}}>
        <Typography variant="h6" >Selected Items</Typography>
        {selectedItems.length == 0 ? (
            <Typography sx={{color: "var(--background-color)"}}>No items selected</Typography>
        ): selectedItems.length > 0 && selectedItems.length < 5 ? (
          <List sx={{ columnCount: 4 }}>
            {selectedItems.map((selectedItem, index) => (
              <ListItem key={index}>
                <ListItemText primary={selectedItem} style={{backgroundColor:'var(--background-color)', padding:'3%', borderRadius: '5px'}}/>
              </ListItem>
            ))}
          </List>
        ) :  (
          <Typography sx={{color: "var(--background-color)"}}>You can select maximum of 4 items only</Typography>
        )}
      </Box>

      {/* Submit button */}
      <Button 
        variant="contained" 
        sx={{ mt: 2 }} 
        onClick={handleSubmit} 
        disabled={selectedItems.length === 0}
        style={{
          backgroundColor: 'var(--orange)',
          color: 'var(--background-color)'
        }}
      >
        Place Your Order
      </Button>
    </Box>
  );
}
