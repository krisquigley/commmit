import { Sortable } from '@shopify/draggable'

const addTickets = document.querySelectorAll("button[data-behavior='addTicket']")
const removeTickets = document.querySelectorAll("button[data-behavior='removeTicket']")
const sprintId = document.querySelector("input[data-behavior='sprintId']").value
const openTabButtons = document.querySelectorAll("button[data-behavior='openTab']")

const urlParams = new URLSearchParams(window.location.search)
const myParam = urlParams.get('search')

if (myParam) {
  window.scrollTo(0, document.body.scrollHeight)
}

const calculateEffortRemaining = () => {
  const availableEffort = parseFloat(document.querySelector("input[data-behavior='availableEffort']").value)
  const allEffort = document.querySelectorAll("input[data-behavior='estimatedEffort']")
  const effortRemaining = document.querySelector("span[data-behavior='effortRemaining']")
  let totalEffort = 0

  allEffort.forEach(effort => {
    totalEffort += parseFloat(effort.value)
  })

  effortRemaining.innerHTML = (availableEffort - totalEffort).toFixed(1)
}

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

const addNewRowAndRemoveOldRecord = (target, response, table) => {
  let button
  let callback
  let row

  if (table === 'assignedTickets') {
    button = `<button class="btn btn-danger btn-sm btn-block" data-ticket-id="${response.issue_id}" data-behavior="removeTicket">Remove</button>`
    callback = removeTicketFromSprint
    row = `<tr data-issue-id="${response.issue_id}">
    <td data-behavior="draggable" style="cursor: move;">
        &#8230;
      </td>
      <td>
        ${response.number}
      </td>
      <td>
        <a href='${response.url}'>${response.title}</a>
      </td>
      <td>
        <input type="hidden" value="${response.estimated_effort}" data-behavior="estimatedEffort" />
        ${response.repository_name}
      </td>
      <td>
        ${button}
      </td>
      </tr>`
  } else {
    button = `<button class="btn btn-success btn-sm btn-block" data-ticket-id="${response.issue_id}" data-behavior="addTicket">Add</button>`
    callback = addTicketToSprint
    row = `<tr>
      <td>
        ${response.number}
      </td>
      <td>
        <a href='${response.url}'>${response.title}</a>
      </td>
      <td>
      ${response.repository_name}
      </td>
      <td>
        ${button}
      </td>
      </tr>`
  }

  const tbody = document.querySelector(`tbody[data-behavior='${table}']`)
  tbody.insertAdjacentHTML('beforeend', row)

  target.parentElement.parentElement.remove()
  
  document.querySelector(`button[data-ticket-id='${response.issue_id}']`)
    .addEventListener('click', callback)

    calculateEffortRemaining()
}

const sortable = new Sortable(document.querySelector('tbody[data-behavior=assignedTickets]'), {
  draggable: 'tr',
  handle: 'td[data-behavior=draggable]'
})

sortable.on('sortable:stop', async (event) => {
  const { sprintId } = event.data.newContainer.dataset
  const { children } = event.data.newContainer
  
  for (let i = 0; i < children.length; i++) {
    try {
      await fetch(`/sprints/${sprintId}/sprint_tickets/${children[i].dataset.issueId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          sprint_ticket: {
            position: i
          }
        })
      })
    } catch (error) {
      console.error(error)
    }
  }
})

const openTab = (event) => {
  const tabName = event.target.innerHTML

  // Get all elements with class="tabcontent" and remove the class "active"
  const tabcontent = document.getElementsByClassName('tabcontent')
  for (let i = 0; i < tabcontent.length; i++) {
    tabcontent[i].className = tabcontent[i].className.replace(' active', '')
  }

  // Get all elements with class="tablinks" and remove the class "active"
  const tablinks = document.getElementsByClassName('tablinks')
  for (let i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(' active', '')
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.querySelector(`div[data-behavior='${tabName}']`).className += ' active'
  event.currentTarget.className += ' active'
}

addTickets.forEach(ticket => {
  ticket.addEventListener('click', addTicketToSprint)
})
removeTickets.forEach(ticket => {
  ticket.addEventListener('click', removeTicketFromSprint)
})
openTabButtons.forEach(tabButton => {
  tabButton.addEventListener('click', openTab)
})
