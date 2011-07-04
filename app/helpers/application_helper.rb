# TODO: Néttoyer, réorganiser, toussa…

module ApplicationHelper
  def day_names
    I18n.t('date.day_names')
  end

  # Title

  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options)
  end

  def title_tag
    content_tag(:title, content_for(:title).empty?  ? 'Site étu : Le nouveau Face-Twit-Goog-Micro-LinuxFr' : content_for(:title))
  end

  # Select options

  def parent_select_options(name)
    options_for_select(
      nested_set_options(name) do |i|
        asso = i.parent ? "(#{i.parent.name})" : ''
        "#{'..' * i.level} #{i.name} #{asso}"
      end.unshift(['Pas de parent', nil])
    )
  end

  def associations_select(object)
    options_for_select(Association.all.map { |a| [a.name, a.id] }, object.associations.map(&:id))
  end

  def events_select(object)
    default = object.event ? object.event.id : nil
    options_for_select(Event.all.map { |a| [a.title, a.id] }.unshift(['Aucun', nil]), default)
  end

  def course_select(object)
    default = object.course ? object.course.id : nil
    options_for_select(Course.all.map { |a| [a.name, a.id] }.unshift(['Aucun', nil]), default)
  end

  def users_select(object = nil)
    default = object.nil? ? nil : object.users.map(&:id)
    options_for_select(User.all.map { |a| [a.login, a.id] }, default)
  end

  def week_select(object)
    options_for_select([nil, 'A', 'B'], object.week)
  end

  def day_select(object)
    options_for_select(day_names.map {|d| [d, day_names.index(d)]}, day_names[object.day])
  end

  # Links to

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr, comments=false)
    if objects.empty?
      return nil
    else
      res = descr.empty? ? '' : '<strong>' + h(descr) + '</strong> :'
      res += '<ul>'
      objects.each do |object|
        content = object.send(attr)
        if comments
          object = [object.commentable, object]
        end
        res += '<li>' + link_to(content, object) + '</li>'
      end
      res += '</ul>'
      return res.html_safe
    end
  end

  # Je laisse ces tentatives foireuses car il ne doit pas manquer grand chose
  # pour que ça fonctionne...
  #def link_to(*args)
  #  link = super *args;
  #  logger.info args.last
  #  return link if args.last.instance_of? String
  #  #return link if can? :access, link
  #  return link if can? :read, args.last
  #  'nope'
  #end

  #def link_to(body, url, html_options = {})
  #  logger.info url.class
  #  return '???' if url.is_a? String
  #  return super body, url if can? :read, url
  #  return super body, url if url == :root
  #  logger.info url.inspect
  #  'nope'
  #end

  #def show_link(body, url)
  #  logger.info url.inspect
  #  c = ActionController::Routing::Routes.recognize_path(url)[:controller]
  #  logger.info "lol" if can? :read, url
  #  link_to(body, url) if can? :read, url
  #end

  def show_link(body, type)
    url = '/' + type.to_s.pluralize.downcase
    link_to body, url if can? :read, type
  end

  def link_to_user(user)
    return link_to user.login, user
  end

  def link_to_users(users)
    if users.empty?
      return 'Aucun'
    else
      return users.map { |u| link_to_user u}.join(' ').html_safe
    end
  end

  def link_to_tags(content)
    if content.tags.empty?
      return 'Aucun'
    else
      return content.tags.map{|t| link_to t.name, Tag.find(t.id) }.join(' ').html_safe
    end
  end

  def link_to_associations(object)
    if object.associations.empty?
      return 'Aucune'
    else
      return object.associations.map { |a| link_to a.name, a }.join(' ').html_safe
    end
  end

  # Others

  def courses_when(day, hour, timesheets)
    timesheets.select {|t| t.during?(day, hour)}.map(&:course)
  end
end
