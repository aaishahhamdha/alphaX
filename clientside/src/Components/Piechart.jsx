import * as React from 'react';
import { PieChart } from '@mui/x-charts/PieChart';

const data = [
  { label: 'Veg', value: 400, color: 'linear-gradient(135deg, #4caf50, #388e3c)' },
  { label: 'Non-Veg', value: 300, color: 'linear-gradient(135deg, #ff5722, #e64a19)' },
];

export default function StraightAnglePieChart() {
  return (
    <PieChart
      series={[
        {
          startAngle: -180,
          endAngle: 180,
          data,
          innerRadius: 50, // Adjust as needed
          outerRadius: 100, // Adjust as needed
          getColor: (point) => point.color, // Use gradient colors for each slice
        },
      ]}
      height={250}
      sx={{
        '.MuiChartsPieSeries-root > path': {
          stroke: '#333', // Border color for depth
          strokeWidth: 1,
        },
      }}
    />
  );
}
