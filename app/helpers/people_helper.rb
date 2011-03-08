module PeopleHelper

  def project_position_options(ct, ix)
    ct = [1, ct].max
    s = "<option value='0'>&mdash;</option>"
    s << (1 .. ct).map { |e| 
      "<option value='#{e}'#{e == ix ? " selected='selected'" : ''}>#{e}</option>" 
    }.join('') 
    s.html_safe
  end

  def login_button(person)
    if get_user == person
      button_to( 'Sign Off', logout_person_path(person))
    else
      button_to( 'Sign On', login_person_path(person))
    end
  end
end
