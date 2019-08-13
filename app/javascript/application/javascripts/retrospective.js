import 'bootstrap'

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

const retrospectiveFeedback = document.querySelector("form[data-behavior='retrospectiveFeedback']")
const userHappiness = document.querySelectorAll("form[data-behavior='userHappiness']")

const submitForm = async (event) => {
  event.preventDefault()
  const inputs = event.target.elements
  const body = {}
  let method = event.target.method

  for (let i = 0; i < inputs.length; i++) {
    let resource = inputs[i].name.split('[')[0]

    // Set the resource key on the body object
    body[`${resource}`] === undefined ? body[`${resource}`] = {} : null
    
    // Override method if it isn't GET or POST
    inputs[i].name === '_method' ? method = inputs[i].value : null

    let name = inputs[i].name.split('[')[1]
    if (name) {
      name = name.slice(0, -1)
      body[`${resource}`][`${name}`] = inputs[i].value
    }
  }

  try {
    const response = await fetch(event.target.action, {
      method: method.toUpperCase(),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify(body)
    })

    if (response.status === 200) {
      for (let i = 0; i < inputs.length; i++) {
        inputs[i].setAttribute('disabled', '')
      }
    }

  } catch (error) {
    console.error(error)
  }
}

retrospectiveFeedback.addEventListener('submit', submitForm)
userHappiness.forEach(user => {
  user.addEventListener('submit', submitForm)
})