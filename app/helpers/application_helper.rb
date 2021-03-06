# encoding: UTF-8

module ApplicationHelper
  # Titre de la page

  # Définit quel va être le titre de la page
  # Retourne un titre <h1> qui peut être affiché
  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options.merge(class: 'title'))
  end

  # Titre utilisé dans le layout
  def title_tag
    content_tag(:title, content_for(:title).empty? ? t('helpers.title') : content_for(:title))
  end

  # Current path to the RSS feed
  def current_rss(controller)
    controller = 'news' unless controller.in?(%w[events classifieds])
    link = {controller: controller, format: 'rss', only_path: false}
    auto_discovery_link_tag(:rss, link)
  end

  # Raccourcis pour les vues

  # <dd> à condition que ce qui est montré ne soit pas vide
  def not_empty_dd(descr, value)
    return nil if value.blank?
    content_tag(:dt, descr) + content_tag(:dd, value)
  end

  # <strong> à condition que ce qui est montré ne soit pas vide
  def not_empty_inline(descr, value, paragraph = false)
    return nil if value.blank?
    res = content_tag(:strong, descr) + " : #{h(value)} ".html_safe
    paragraph ? content_tag(:p, res) : res
  end

  # Select options
  def parent_select_options(name)
    options_for_select(
      nested_set_options(name) do |object|
         "#{'..' * object.level} #{object.to_s}"
      end.unshift([t('helpers.noparent'), nil])
    )
  end

  # General select : need the objects that can be selected
  # And optionally the selected objects
  # And also optionally if the user can select no objects
  def select_objects(objects, selected = [], none = false)
    objects ||= []
    selected ||= []
    objects = ((selected && objects) || []).map { |object| [object.to_s, object.id] }
    objects.unshift([t('common.none'), nil]) if none

    selected = [selected] unless selected.is_a? Array
    selected = selected.compact.map(&:id)

    options_for_select(objects, selected)
  end

  # List of objects (use the #to_s method)
  # Can be inline or in a list
  def links_to_objects(objects, list = false)
    if objects.blank?
      content_tag(:p, t('common.none'))
    else
      if list
        content_tag(:ul) do
          objects.map do |object|
            content_tag(:li, link_to(object.to_s, object))
          end.join.html_safe
        end
      else
        objects.map { |object| link_to(object.to_s, object) }.join(', ').html_safe
      end
    end
  end

  # Button to delete a resource (with confirmation)
  def button_to_delete(label, link)
    button_to label, link, confirm: t('common.confirm'), method: :delete
  end

  # Complete search form
  def search_form(path)
    form_tag(path, method: :get) do
      text_field_tag(:q, params[:q]) + ' ' + submit_tag(t('common.search'))
    end
  end
end
