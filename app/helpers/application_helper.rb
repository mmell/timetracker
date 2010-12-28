module ApplicationHelper
  
  def csv_sum_rows(column, start_row, row_ct)
    column.upcase!
    end_row = start_row + row_ct
    %Q{=SUM(#{column}#{start_row}:#{column}#{end_row})}
  end
  
  def get_user
    controller.get_user
  end
  
  def link_class(opts)
    current_page?(opts) ? 'current' : ''
  end
  
  def user_time_zone(user = get_user)
    (user ? user.time_zone : nil)
  end
  
  def user_time(t, user = get_user) 
    t.in_time_zone(user_time_zone(user))
  end
  
  def user_time_now(user = get_user)
    user_time(Time.now.utc, user)
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
