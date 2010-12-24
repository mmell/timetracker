module ApplicationHelper
    
  def csv_row(arr) 
    arr.map { |e| 
      e = e.to_s
      if e.index(',') or e.index('"') or e.index("\n")
        %Q{"#{e.gsub('"', '""')}"} # personally I'd rather quote all fields =mike
      else 
        e
      end
      }.join(",")
  end
  
  def get_user
    controller.get_user
  end
  
  def link_class(opts)
    current_page?(opts) ? 'current' : ''
  end
  
  def user_time_zone
    (get_user ? get_user.time_zone : nil)
  end
  
  def user_time(t) 
    t.in_time_zone(user_time_zone)
  end
  
  def user_time_now()
    user_time(Time.now.utc)
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
