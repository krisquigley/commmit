const repo = document.querySelector('select[data-behavior=repo-filter]').selectedOptions[0].value
console.log('here', repo)
<%# <%= Ticket.order(created_at: :desc).where(repository_name: repo) %> %>