import moment from 'moment'
import Chart from 'chart.js'
moment.locale('en-GB')
const ctx = document.getElementById('myChart').getContext('2d')
const effortAccountedFor = document.querySelector("input[data-behavior='effortAccountedFor']").value
const startDate = document.querySelector("[data-behavior='startDate']").value
const endDate = document.querySelector("[data-behavior='endDate']").value
const effortToDate = document.querySelector("[data-behavior='effortToDate']").value
const updateNoteRows = document.querySelectorAll("textarea[data-behavior='updateNote']")
const weekends = [6, 7]

const dates = () => {
  const days = []
  let weekdays = 0
  let day = moment(startDate)

  while (day <= moment(endDate)) {
    // Caculate how many weekdays there are in this sprint
    if (!weekends.includes(day.weekday())) {
      weekdays++
    }

    // Create an array of all the dates in the sprint
    days.push(day.format('D/M/Y'))
    day = moment(day.add(1, 'days'))
  }

  return { days: days, weekdays: weekdays }
}

const idealEffort = () => {
  const { days, weekdays } = dates()

  let totalWeekendsPassed = 0
  let previousIdealEffortValue = 0

  const values = days.map((day, index) => {
    let dayOfWeek = moment(day, 'D/M/Y').weekday()

    if (weekends.includes(dayOfWeek)) {
      // Calculate how many weekend days have passed up to this point
      totalWeekendsPassed++

      // As this is on the weekend, use the previous effort value
      return previousIdealEffortValue
    } else {
      let idealEffort = effortAccountedFor - (effortAccountedFor / (weekdays - 1)) * (index - totalWeekendsPassed)

      previousIdealEffortValue = idealEffort
      return idealEffort
    }
  })

  return values
}

new Chart(ctx, {
  type: 'line',
  data: {
    labels: dates().days,
    datasets: [{
      label: 'Ideal Effort Remaining',
      data: idealEffort(),
      fill: false,
      borderDash: [5, 5],
      lineTension: 0,
      pointRadius: 0
    },
    {
      label: 'Effort Remaining',
      data: JSON.parse(effortToDate),
      lineTension: 0,
      backgroundColor: [
        'rgba(210, 14, 171, 0.2)'
      ],
      borderColor: [
        'rgba(210, 14, 171, 1)'
      ]
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      yAxes: [{
        ticks: {
          beginAtZero: true
        }
      }]
    }
  }
})

const updateNote = (event) => {
  const options = {
    body: {
      sprint_ticket: {
        notes: event.target.value
      }
    },
    id: event.target.attributes['data-id'].value
  }
  updateSprintTicket(options)
}

updateNoteRows.forEach(row => {
  row.addEventListener('change', updateNote)
})

const updateSprintTicket = async (options) => {
  const { id, body } = options

  try {
    await fetch(`/sprint_tickets/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify(body)
    })
  } catch (error) {
    console.error(error)
  }
}
