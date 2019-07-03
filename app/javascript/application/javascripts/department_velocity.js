import moment from 'moment'
import Chart from 'chart.js'
import 'chartjs-plugin-trendline'
moment.locale('en-GB')

const ctx = document.getElementById('departmentVelocity').getContext('2d')
const velocityValues = JSON.parse(document.querySelector('input[data-behavior=velocity_values]').value)
const teamNames = JSON.parse(document.querySelector('input[data-behavior=teams]').value).map(team => team['name'])
// Get the unique dates
const dates = [...new Set(velocityValues.map(velocity => moment(velocity["end_date"]).format('L')))]
const teamChartData = []

teamNames.forEach(teamName => {
  const teamData = velocityValues.filter(velocity => velocity['name'] === teamName)
  const velocities = []
  
  dates.forEach((date, index) => {
    // If there is a sprint for this date then add the velocity
    teamData.forEach(velocity => {
      if (moment(velocity["end_date"]).format('L') === date) {
        velocities.push(Math.floor(velocity["final_velocity"]))
      } 
    })
    
    // If there is no sprint for this date then set velocity to 0
    if (!velocities[index]) {
      velocities.push(0)
    }
  })
  
  // Add velocity for team to graph
  teamChartData.push({ 
    label: teamName, 
    data: velocities, 
    fill: false,
    lineTension: 0,
    pointRadius: 0,
    backgroundColor: hashCode(teamName),
    borderColor:  hashCode(teamName)
  })
})

const teamVelocities = teamChartData.map(team => team.data)
const combinedVelocities = []
for (let i = 0; i < teamVelocities[0].length; i++) {
  let velocity = 0
  for (let v = 0; v < teamVelocities.length; v++) {
    velocity += teamVelocities[v][i]
  }
  combinedVelocities.push(velocity)
}

// Add the combined velocity data
teamChartData.push({
  label: 'Combined Velocity', 
  data: combinedVelocities, 
  fill: false,
  borderDash: [5, 5],
  lineTension: 0,
  pointRadius: 0,
  trendlineLinear: {
    style: "#3e95cd",
    lineStyle: "line",
    width: 1
  }
})

new Chart(ctx, {
  type: 'line',
  data: {
    labels: dates,
    datasets: teamChartData
  },
  options: {
    title: {
      display: true,
      text: 'Velocity per Team'
    },
    responsive: true,
    maintainAspectRatio: false,
  }
})

function hashCode(str) { // java String#hashCode
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  let colour = '#';
  for (var i = 0; i < 3; i++) {
    let value = (hash >> (i * 8)) & 0xFF;
    colour += ('00' + value.toString(16)).substr(-2);
  }
  return colour;
}