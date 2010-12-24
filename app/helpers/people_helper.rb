module PeopleHelper
  def login_button(person)
    if get_user == person
      button_to( 'Logout', logout_person_path(person))
    else
      button_to( 'Login', login_person_path(person))
    end
  end
end
