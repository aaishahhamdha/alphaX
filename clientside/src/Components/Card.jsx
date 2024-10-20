import React, { useEffect, useState } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import CardActionArea from '@mui/material/CardActionArea';
import '../index.css';

export default function CustomCard() {
  const [mealtimeData, setMealtimeData] = useState({}); 
  const apiUrl = 'http://localhost:9090/api/orderCounts'; 

  
  useEffect(() => {
    const fetchMealtimeData = async () => {
      try {
        const response = await fetch(apiUrl);
        console.log(response);
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        const data = await response.json();
        setMealtimeData(data); 
      } catch (error) {
        console.error('Failed to fetch mealtime data:', error);
      }
    };

    fetchMealtimeData();
  }, [apiUrl]);

  return (
    <div style={{ display: 'block', flexWrap: 'wrap'}}>
      {Object.keys(mealtimeData).map((mealtime) => (
        <Card key={mealtime} sx={{ margin: '2px', padding: '3px'}}>
          <CardActionArea>
            <CardContent sx={{display: 'flex', justifyContent: 'space-between'}}>
              <Typography sx={{ fontSize: 'var(--font-size-heading)', color:'var(--text-primary)' }}>
                {mealtime} 
              </Typography>
              <Typography  sx={{fontSize: 'var(--font-size-subheading)' }}>
                {mealtimeData[mealtime].Veg + mealtimeData[mealtime]['Non-veg'] + mealtimeData[mealtime].Egg}
              </Typography>
            </CardContent>
          </CardActionArea>
        </Card>
      ))}
    </div>
  );
}
