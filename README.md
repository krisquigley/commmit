# Todo
 - Rename actual effort to effort spent
 - Add pagination to sprints index
 - Add slugs to sprints
 - Add column to sprint to manage % of time reviewing etc
 - Add settings table to manage % of time reviewing etc across the app, default to 20
 - Make position of sprint ticket when adding it to a sprint to be sprint_tickets.count (done)
 - Add available effort and effort remaining to manage sprint page (done)
 - Remove Available Effort	Effort Accounted for	Team	Status from show page (done)
 - Allow for ordering of sprint tickets inside a sprint (done)
 - Add filter to tickets in manage (done)
 - Add search to tickets in manage (done)
 - Allow for manual override of estimated effort on a sprint ticket (done)
 - Use decimals for estimated effort and actual effort (done)
 - Update sprint tickets from github webhook where sprints are not closed at and issue updated_at >= start_date and <= end_date (done)
 - If a ticket is closed without actual_effort being set it raises an error (done)
 - Update chart to use effort account for rather than available effort for the burndown (done)
 - Error is raised when updating holiday (done)
 - Lock down tickets once sprint has been closed (done)
 - Closing an issue on the same start_date of the sprint does not update the chart (done)
 - Add option to close sprint early, which updates end_date to Time.now (done)


