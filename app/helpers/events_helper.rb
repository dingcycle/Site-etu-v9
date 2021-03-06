module EventsHelper
  # Link to add the event to Google Agenda
  def google_agenda_link(event)
    name = CGI::escape(event.name)
    location = CGI::escape(event.location.to_s)
    start_at = event.start_at ? l(event.start_at - 2.hours, format: "%Y%m%dT%H%M%SZ") : ''
    end_at = event.end_at ? l(event.end_at - 2.hours, format: "%Y%m%dT%H%M%SZ") : ''
    description = CGI::escape(event.description.to_s)

    link_to image_tag("others/google_agenda.png"),
      "https://www.google.com/calendar/b/0/render?action=TEMPLATE&text=#{name}&location=#{location}&dates=#{start_at}/#{end_at}&details=#{description}&pli=1&sf=true&output=xml",
      title: t('helpers.add_agenda')
  end

  # Link to send the event by mail
  def mailto_link(event)
    mail_to '', image_tag("others/mailto.png"),
      subject: "[#{t('helpers.utt_event')}] #{event.name}",
      body: "#{event.description}\n\n#{t('helpers.event_content', url: request.url)}",
      title: t('helpers.invite_people')
  end
end
