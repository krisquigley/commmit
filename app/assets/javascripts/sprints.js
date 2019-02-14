const addTickets = document.querySelectorAll("span[data-behavior='addTicket']")
const removeTickets = document.querySelectorAll("span[data-behavior='removeTicket']")
const assignedTickets = document.querySelector("tbody[data-behavior='assignedTickets']")

const addTicketToSprint = async (event) => {
  event.preventDefault()

  const { target } = event
  const sprintId = target.attributes['data-sprint-id'].value
  const ticketId = target.attributes['data-ticket-id'].value
  
  try {
    const response = await fetch(`/sprints/${sprintId}/sprint_tickets`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        issue_id: ticketId
      })
    })

    response.json().then(response => {
      addNewRowAndRemoveOldRecord(target, response, 'assignedTickets')
    })
  } catch (error) {
    console.error(error)
  }
}

const removeTicketFromSprint = async (event) => {
  event.preventDefault()

  const { target } = event
  const sprintId = target.attributes['data-sprint-id'].value
  const ticketId = target.attributes['data-ticket-id'].value

  try {
    const response = await fetch(`/sprints/${sprintId}/sprint_tickets/${ticketId}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    response.json().then(response => {
      addNewRowAndRemoveOldRecord(target, response, 'availableTickets')
    })

  } catch (error) {
    console.error(error)
  }
}

addTickets.forEach(ticket => {
  ticket.addEventListener('click', addTicketToSprint)
})
removeTickets.forEach(ticket => {
  ticket.addEventListener('click', removeTicketFromSprint)
})

const addNewRowAndRemoveOldRecord = (target, response, table) => {
  let button
  let callback

  if (table === 'assignedTickets') {
    button = `<span class="btn btn-danger" data-ticket-id="${response.issue_id}" data-sprint-id="${response.sprint_id}" data-behavior="removeTicket">Remove</span>`
    callback = removeTicketFromSprint
  } else {
    button = `<span class="btn btn-success" data-ticket-id="${response.issue_id}" data-sprint-id="${response.sprint_id}" data-behavior="addTicket">Add</span>`
    callback = addTicketToSprint
  } 
  
  const tbody = document.querySelector(`tbody[data-behavior='${table}']`)
  tbody.insertAdjacentHTML('beforeend', `<tr>
    <td>
    ${response.title}
    </td>
    <td>
      ${response.repository_name}
      </td>
    <td>
      ${button}
    </td>
  </tr>`)

  document.querySelector(`span[data-ticket-id='${response.issue_id}']`)
    .addEventListener('click', callback)

  target.parentElement.parentElement.remove()
}
