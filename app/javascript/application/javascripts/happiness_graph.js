import moment from 'moment'
import Chart from 'chart.js'
moment.locale('en-GB')

const ctx = document.getElementById('happiness').getContext('2d')
const happinessValues = JSON.parse(document.querySelector('input[data-behavior=happiness_values]').value)

const dates = happinessValues.map(happy => moment(happy["created_at"]).format('L'))
const roleHappiness = happinessValues.map(happy => happy["role_happiness"])
const teamHappiness = happinessValues.map(happy => happy["team_happiness"])
const companyHappiness = happinessValues.map(happy => happy["company_happiness"])

const averageHappiness = happinessValues.map(happy => {
  if (happy["team_happiness"]) {
    return ((happy["role_happiness"] + happy["team_happiness"] + happy["company_happiness"]) / 3).toFixed(1)
  } else {
    return ((happy["role_happiness"] + happy["company_happiness"]) / 2).toFixed(1)
  }
})

new Chart(ctx, {
  type: 'bar',
  data: {
    labels: dates,
    datasets: [{
      type: 'line',
      label: 'Average',
      data: averageHappiness,
      fill: false,
      borderDash: [5, 5],
      lineTension: 0,
      pointRadius: 0
    },
    {
      type: 'bar',
      label: 'Role Happiness',
      data: roleHappiness,
      fill: false,
      backgroundColor: '#aef35A',
      borderColor: 'white',
    },
    {
      type: 'bar',
      label: 'Team Happiness',
      data: teamHappiness,
      fill: false,
      backgroundColor: '#98edc3',
      borderColor: 'white',
    },
    {
      type: 'bar',
      label: 'Company Happiness',
      data: companyHappiness,
      fill: false,
      backgroundColor: '#03c04a',
      borderColor: 'white',
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    tooltips: {
      mode: 'index',
      intersect: true
    },
    scales: {
      yAxes: [{
        ticks: {
          beginAtZero: true
        }
      }]
    }
  }
})