let ctx = document.getElementById('myChart').getContext('2d')

const totalEffort = document.querySelector("[data-behavior='totalEffort']").innerHTML
const effortUsed = document.querySelector("[data-behavior='effortUsed']").value
const startDate = document.querySelector("[data-behavior='startDate']").value
const endDate = document.querySelector("[data-behavior='endDate']").value
const effortToDate = document.querySelector("[data-behavior='effortToDate']").value

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
    return (totalEffort / (numberOfDays - 1)) * index
  })

  return values.reverse()
}

console.log(totalEffort, effortUsed, startDate, endDate, effortToDate)

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
      lineTension: 0
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      yAxes: [{
        ticks: {
          beginAtZero:true
        }
      }]
    }
  }
})
