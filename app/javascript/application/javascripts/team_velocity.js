import moment from 'moment'
import Chart from 'chart.js'
moment.locale('en-GB')

const ctx = document.getElementById('teamVelocity').getContext('2d')
const velocityValues = JSON.parse(document.querySelector('input[data-behavior=velocity_values]').value)

const dates = velocityValues.map(velocity => moment(velocity["end_date"]).format('L'))
const velocity = velocityValues.map(velocity => Math.floor(velocity["final_velocity"]))

new Chart(ctx, {
  type: 'line',
  data: {
    labels: dates,
    datasets: [{
      label: 'Velocity',
      data: velocity,
      fill: false,
      lineTension: 0,
      pointRadius: 0,
      backgroundColor: ['rgba(0,0,0,0)'],
      borderColor: ['red']
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    stacked: false
  }
})