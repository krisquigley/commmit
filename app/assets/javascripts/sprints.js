const addTickets = document.querySelectorAll("button[data-behavior='addTicket']")
const removeTickets = document.querySelectorAll("button[data-behavior='removeTicket']")
const sprintId = document.querySelector("input[data-behavior='sprintId']").value

const addTicketToSprint = async (event) => {
  event.preventDefault()

  const { target } = event
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
    button = `<button class="btn btn-danger btn-sm" data-ticket-id="${response.issue_id}" data-behavior="removeTicket">Remove</button>`
    callback = removeTicketFromSprint
  } else {
    button = `<button class="btn btn-success btn-sm btn-block" data-ticket-id="${response.issue_id}" data-behavior="addTicket">Add</button>`
    callback = addTicketToSprint
  }

  const tbody = document.querySelector(`tbody[data-behavior='${table}']`)
  tbody.insertAdjacentHTML('beforeend', `<tr>
    <td>
      <a href='${response.url}'>${response.title}</a>
    </td>
    <td>
      ${response.repository_name}
    </td>
    <td>
      ${button}
    </td>
  </tr>`)

  target.parentElement.parentElement.remove()

  document.querySelector(`button[data-ticket-id='${response.issue_id}']`)
    .addEventListener('click', callback)
}
