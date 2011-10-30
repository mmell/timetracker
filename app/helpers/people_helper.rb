module PeopleHelper

  def project_position_options(ct, ix)
    s = "<option value='0'>&mdash;</option>"
    s << (1 .. ct).map { |e|
      "<option value='#{e}'#{e == ix ? " selected='selected'" : ''}>#{e}</option>" 
    }.join('')
    if ix == 0 
      ct += 1
      s << "<option value='#{ct}'>#{ct}</option>" 
    end
    s.html_safe
  end

  def login_button(person)
    if get_user == person
      button_to( 'Sign Out', logout_person_path(person))
    else
      button_to( 'Sign In', login_person_path(person))
    end
  end
end
