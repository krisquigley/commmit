# frozen_string_literal: true

module SprintTicketsHelper
  def labels(ticket)
    # TODO: Refactor using content_tags
    if ticket.source?
      labels = (JSON.parse(ticket.source).try('labels') ||
                  JSON.parse(ticket.source).try('issue').try('labels') || [])
               .map do |l|
                 "<span class=\"badge\" style=\"background-color: ##{l['color']}\">"\
                    "#{l['name']}"\
                  '</span>'
               end

      labels.join(' ').html_safe
    end
  end

  def closed_at_formatted(ticket)
    ticket.closed_at&.to_date&.to_formatted_s(:long) || 'Open'
  end
end
