module PeopleHelper
  def login_button(person)
    if get_user == person
      button_to( 'Sign Off', logout_person_path(person))
    else
      button_to( 'Sign On', login_person_path(person))
    end
  end
end
