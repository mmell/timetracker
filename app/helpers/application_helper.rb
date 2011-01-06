module ApplicationHelper
  
  def project_cookie_crumbs(project)
    a = [link_to(project.name, project_path(project))]
    while project.parent_id
      project = project.parent
      a = [link_to(project.name, project_path(project))] + a
    end
    a.join('::')
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
