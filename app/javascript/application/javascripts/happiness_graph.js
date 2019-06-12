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
    return Math.floor((happy["role_happiness"] + happy["team_happiness"] + happy["company_happiness"]) / 3)
  } else {
    return Math.floor((happy["role_happiness"]  + happy["company_happiness"]) / 2)
  }
})

new Chart(ctx, {
  type: 'line',
  data: {
    labels: dates,
    datasets: [{
      label: 'Role Happiness',
      data: roleHappiness,
      lineTension: 0,
      fill: false,
      backgroundColor: ['#aef35A'],
      borderColor: ['#aef35A'],
    },
    {
      label: 'Team Happiness',
      data: teamHappiness,
      lineTension: 0,
      fill: false,
      backgroundColor: ['#98edc3'],
      borderColor: ['#98edc3'],
    },
    {
      label: 'Company Happiness',
      data: companyHappiness,
      lineTension: 0,
      fill: false,
      backgroundColor: ['#03c04a'],
      borderColor: ['#03c04a'],
    },
    {
      label: 'Average',
      data: averageHappiness,
      fill: false,
      borderDash: [5, 5],
      lineTension: 0,
      pointRadius: 0
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false
  }
})