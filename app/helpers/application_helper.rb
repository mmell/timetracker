module ApplicationHelper
  def project_select(project, selected_id = nil)
    selected = (selected_id and project.id == selected_id ? " selected='true'" : '')
    "<option value='#{project.id}'#{selected}>#{h project.fullname}</option>"
  end

  def sub_projects_select(projects, selected_id = nil)
    selected_id = selected_id.id if selected_id.is_a?(Project)
    projects.map { |e| project_select(e, selected_id) }.join().html_safe
  end

  def link_to_projects(project)
    last = (current_page?(project) ? "<strong>#{h( project.name)}</strong>" : link_to(h(project.name), project_path(project)) )
    a = [last]
    while !project.parent_id.nil?
      project = project.parent
      a = [link_to_unless(current_page?(project), h(project.name), project_path(project))] + a
    end
    a.join('::').html_safe
  end

  def link_to_project_url(project)
    # FIXME is the url unsafe?
    project.url.blank? ? '' : "(#{link_to( h( project.url), project.url, { :target => 'project_url', :class => 'project_url'})})".html_safe
  end

  def get_user
    controller.get_user
  end

  def link_class(opts)
    current_page?(opts) ? 'current' : ''
  end

  def truncate(s, n = 24)
#    return s # truncating in the middle of a tag element, e.g. <p>, makes problems
    return s if s.length < n
    n = n1 if n1 = s.rindex(/\s/, n) and n1 < n # and !n1.nil?
    sanitize(s[0, n] + ' ...')
  end

  def truncate_url(s, n = 24)
    s = s.sub(/^https?:\/\//, '').sub(/^www\./, '')
    truncate(s, n)
  end

end
