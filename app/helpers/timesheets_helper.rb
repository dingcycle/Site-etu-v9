# encoding: utf-8

module TimesheetsHelper
  # Emploi du temps
  # Traduit une suite de paramètres en un hash prêt à être utilisé
  # object est l'objet vers lequel on va lier la case qui l'affiche
  # Le hash peut contenir un évènement ou une horaire.
  def event_to_json(hash)
    return nil unless hash.detect { |k, v| v.nil? }.nil?

    {
      'title' => h(hash['title']),
      'start' => hash['start_at'].iso8601,
      'end' => hash['end_at'].iso8601,
      'url' => url_for(hash['object']),
      'allDay' => hash['allDay'],
      'color' => hash['color'],
    }
  end

  # Passe de ["MATH01", "LE08", ...] (ou ["Dorian", "Cédric", ...]) à :
  # {"MATH01" => "#231233", "LE08" => "#981822", ...}
  def map_tags_to_colors(tags)
    # Couleurs différentes, foncées
    colors = ['#343D91', '#346F91', '#34916D', '#349143', '#599134', '#899134',
              '#916734', '#914034', '#913457', '#91347E', '#7B3491']

    # On va associer à chaque cours une couleur
    i = 0
    hash = {'_default' => '#6579C5'} # Va contenir les couples "UV" => "#couleur"
    tags.each do |tag|
      hash[tag] = colors[i]
      i = (i+1) % colors.size # Va au début si ya trop de cours différents
    end
    hash
  end

  # Hash of timesheets/events/... to JSON (with color, etc...)
  def agenda_to_json(array_of_hash)
    if array_of_hash.first.is_a? Timesheet
      array_of_hash = array_of_hash.map(&:to_fullcalendar)
    end

    agenda = []

    # Les cours
    tags = array_of_hash.map { |hash| hash['tag'] }.compact.uniq
    # Une couleur est associée à chaque cours
    colors = map_tags_to_colors(tags)

    # On remplit l'emploi du temps selon les normes de FullCalendar
    array_of_hash.map do |hash|
      hash['color'] = colors[hash['tag'] || '_default']
      object = event_to_json(hash)
      agenda << object
    end

    agenda.compact.to_json.html_safe
  end

  def start_date_of_semester
    date = SEMESTERS.last['start_at']

    {
      'year' => date.year,
      'month' => date.month - 1,
      'day' => date.day
    }.to_json.html_safe
  end

  def dates_translations
    dates = {
      'monthNames' => I18n.t('date.month_names').compact,
      'monthNamesShort' => I18n.t('date.abbr_month_names').compact,
      'dayNames' => I18n.t('date.day_names'),
      'dayNamesShort' => I18n.t('date.abbr_day_names'),
    }

    dates.to_json.html_safe
  end

  def agenda_for_noscript(agenda)
    agenda.map do |t|
      { alt: t['alt'], url: url_for(t['object']) }
    end.uniq
  end
end
