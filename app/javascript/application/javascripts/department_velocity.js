import moment from 'moment'
import Chart from 'chart.js'
moment.locale('en-GB')

const ctx = document.getElementById('departmentVelocity').getContext('2d')

new Chart(ctx, {
  type: 'line',
  data: {
    labels: ['05/04/2019', '12/04/2019', '18/04/2019', '26/04/2019', 
             '02/05/2019', '10/05/2019', '17/05/2019', '24/05/2019', 
             '31/05/2019', '07/06/2019'],
    datasets: [{
      label: 'Velocity',
      data: [32.1, 55.2, 36.5, 67.3, 73.1, 115.5, 155, 201.5, 117.5, 233],
      fill: false,
      lineTension: 0,
      pointRadius: 0,
      backgroundColor: ['rgba(0,0,0,0)'],
      borderColor: ['red'],
      yAxisID: 'velocity'
    },
    {
      label: 'Happiness',
      data: [3.8, 3.8, 3.8, 4.1, 4.1, 4.2, 4.4, 4.1, 4.3, 4.4],
      lineTension: 0,
      fill: false,
      backgroundColor: ['rgba(0,0,0,0)'],
      borderColor: ['pink'],
      yAxisID: 'happiness'
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    stacked: false,
    scales: {
      yAxes: [{
        type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
        display: true,
        position: 'left',
        id: 'happiness'
      }, {
        type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
        display: true,
        position: 'right',
        id: 'velocity',
        // grid line settings
        gridLines: {
          drawOnChartArea: false, // only want the grid lines for one axis to show up
        }
      }]
    }
  }
})