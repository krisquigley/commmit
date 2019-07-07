import moment from 'moment'
import Chart from 'chart.js'
import 'chartjs-plugin-trendline'
moment.locale('en-GB')

const ctx = document.getElementById('teamVelocity').getContext('2d')
const velocityValues = JSON.parse(document.querySelector('input[data-behavior=velocity_values]').value)
const happinessValues = JSON.parse(document.querySelector('input[data-behavior=happiness_values]').value)
console.log(happinessValues)
const dates = velocityValues.map(velocity => moment(velocity["end_date"]).format('L'))
const velocity = velocityValues.map(velocity => Math.floor(velocity["final_velocity"]))

new Chart(ctx, {
  type: 'bar',
  data: {
    labels: dates,
    datasets: [{
      type: 'line',
      label: 'Velocity',
      data: velocity,
      fill: false,
      lineTension: 0,
      pointRadius: 0,
      backgroundColor: 'rgba(0,0,0,0)',
      borderColor: 'red',
 
      yAxisID: 'velocity'
    },{
      type: 'bar',
      label: 'Average Happiness',
      data: happinessValues,
      fill: false,
      backgroundColor: '#aef35A',
      borderColor: 'white',
      yAxisID: 'happiness'
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    stacked: false,
    tooltips: {
      mode: 'index',
      intersect: true
    },
    title: {
      display: true,
      text: 'Team Velocity'
    },
    scales: {
      yAxes: [{
        type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
        display: true,
        position: 'left',
        id: 'velocity'
      }, {
        type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
        display: true,
        position: 'right',
        id: 'happiness',
        // grid line settings
        gridLines: {
          drawOnChartArea: false, // only want the grid lines for one axis to show up
        }
      }]
    }
  }
})