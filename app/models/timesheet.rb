class Timesheet < ActiveRecord::Base
  CATEGORIES = %w(CM TD TP)

  attr_accessible :start_at, :duration, :week, :category, :room, :course
  validates_presence_of :start_at, :duration, :category, :course
  validates :category, :inclusion => {:in => Timesheet::CATEGORIES}

  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  # Temps défini par cette horaire
  def range
    t_week_day = I18n.l(start_at, :format => :week_day)
    t_start_at = I18n.l(start_at, :format => :hour)
    t_end_at = I18n.l(start_at + duration.minutes, :format => :hour)
    t_week = (week and !week.empty?) ? " (#{I18n.t('model.timesheet.week')} #{week})" : ''

    I18n.t('model.timesheet.range', :short => short_range, :week_day => t_week_day,
      :start => t_start_at, :end => t_end_at, :week => t_week)
  end

  # Description sans les heures
  def short_range
    I18n.t('model.timesheet.short', :category => category,
      :name => course.name, :room => room)
  end

  # Traduit l'horaire en un hash exploitable par FullCalendar
  def to_fullcalendar
    return { 'title' => "#{course.name} #{category}\n#{room}\n#{week}",
             'start_at' => start_at,
             'end_at' => start_at + duration.minutes,
             'object' => self,
             'alt' => range,
             'course' => course.name }
  end

  # Selectionne les horaires du semestre actuel
  def self.make_schedule(timesheets)
    timesheets = [timesheets].compact if timesheets.class != Array
    timesheets = timesheets.uniq

    # Le semestre actuel est le dernier
    semester = SEMESTERS.last
    # On sélectionne les horaires de ce semestre
    timesheets = timesheets.select do |ts|
      ts.start_at >= semester['start_at'] && ts.start_at <= semester['end_at']
    end

    return timesheets
  end

  # Fait la répétition des horaires selon le semestre
  def self.make_agenda(timesheets)
    agenda = []

    # Déjà on selectionne les horaires du semestre
    timesheets = make_schedule(timesheets)

    # Le semestre actuel est le dernier
    semester = SEMESTERS.last

    # On prend chaque horaire et on le répéte
    timesheets.each do |ts|
      start_at = semester['start_at']
      index = 0 # Nombre de semaines depuis la rentrée

      begin
        day = semester['weeks'][index][ts.start_at.wday - 1, 1] # cf lib/semesters.rb

        if (!ts.week.nil? and ts.week == day) or # Semaine A ou semaine B
           (ts.week.nil? and ['A', 'B'].include?(day)) # Il y a cours ce jour là ?
          hash = ts.to_fullcalendar
          # Comme une répétition, on ajoute les semaines
          hash['start_at'] += index.weeks
          hash['end_at'] += index.weeks
          agenda.push(hash)
        end

        index += 1
      # Tant que l'on est dans le semestre
      end while (start_at + index.weeks) < semester['end_at']
    end

    return agenda
  end
end
