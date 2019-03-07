import moment from 'moment'
import Chart from 'chart.js'

let ctx = document.getElementById('myChart').getContext('2d')

const effortAccountedFor = document.querySelector("input[data-behavior='effortAccountedFor']").value
const startDate = document.querySelector("[data-behavior='startDate']").value
const endDate = document.querySelector("[data-behavior='endDate']").value
const effortToDate = document.querySelector("[data-behavior='effortToDate']").value
const updateEffortRows = document.querySelectorAll("input[data-behavior='updateEffort']")
const updateEstimatedEffortRows = document.querySelectorAll("input[data-behavior='updateEstimatedEffort']")
const updateNoteRows = document.querySelectorAll("textarea[data-behavior='updateNote']")

const dates = () => {
  const days = []
  let day = moment(startDate)

  while (day <= moment(endDate)) {
    days.push(day.format('D/M/Y'))
    day = moment(day.add(1, 'days'))
  }

  return days
}

const idealEffort = () => {
  const days = dates()
  const numberOfDays = days.length

  const values = days.map((_, index) => {
    return (effortAccountedFor / (numberOfDays - 1)) * index
  })

  return values.reverse()
}

const myChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: dates(),
    datasets: [{
      label: 'Ideal Effort Remaining',
      data: idealEffort(),
      fill: false,
      borderDash: [5, 5],
      pointRadius: 0
    },{
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

const updateEstimatedEffort = (event) => {
  const options = {
    body: {
      sprint_ticket: {
        estimated_effort_override: event.target.value
      }
    },
    issueId: event.target.attributes['data-issueId'].value,
    sprintId: event.target.attributes['data-sprintId'].value
  }

  updateSprintTicket(options)
}

updateEstimatedEffortRows.forEach(row => {
  row.addEventListener('change', updateEstimatedEffort)
})

const updateEffort = (event) => {
  const options = {
    body: {
      sprint_ticket: {
        effort_spent: event.target.value
      }
    },
    issueId: event.target.attributes['data-issueId'].value,
    sprintId: event.target.attributes['data-sprintId'].value
  }

  updateSprintTicket(options)
}

updateEffortRows.forEach(row => {
  row.addEventListener('change', updateEffort)
})

const updateNote = (event) => {
  const options = {
    body: {
      sprint_ticket: {
        notes: event.target.value
      }
    },
    issueId: event.target.attributes['data-issueId'].value,
    sprintId: event.target.attributes['data-sprintId'].value
  }
  updateSprintTicket(options)
}

updateNoteRows.forEach(row => {
  row.addEventListener('change', updateNote)
})

const updateSprintTicket = async (options) => {
  const { sprintId, issueId, body } = options

  try {
    await fetch(`/sprints/${sprintId}/sprint_tickets/${issueId}`, {
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
