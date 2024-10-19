import * as React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import CardActionArea from '@mui/material/CardActionArea';
import '../index.css'

export default function CustomCard() {
  return (
    <Card sx={{ maxWidth: 150, padding: '10px' }}>
      <CardActionArea>
        <CardContent>
          <Typography gutterBottom variant="h5" component="div" sx={{fontSize: 'var(--font-size-heading)'}}>
            Lizard
          </Typography>
          <Typography variant="body2" sx={{ color: 'text.secondary', fontSize: 'var(--font-size-subheading)'}}>
            Title
          </Typography>
        </CardContent>
      </CardActionArea>
    </Card>
  );
}