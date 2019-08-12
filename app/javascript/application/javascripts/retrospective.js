const retrospectiveFeedback = document.querySelector("form[data-behavior='retrospectiveFeedback']")

const submitRetrospectiveFeedback = async (event) => {
  event.preventDefault()

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

retrospectiveFeedback.addEventListener('submit', submitRetrospectiveFeedback)