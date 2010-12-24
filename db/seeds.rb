# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Person.create(:name => 'Mike Mell', :email => 'mike.mell@nthwave.net', :image_url => 'http://nthwave.net/MikeMell.jpg')
torsten = Person.create(:name => 'Torsten Kolind', :email => 'torsten@younoodle.com')
client = Client.create(:name => 'YouNoodle', :contact => torsten)
project = Project.create(:client => client, :name => 'www.younoodle.com', :url => 'www.younoodle.com')
objective = Objective.create(:project => project, :name => 'Polish Rollout')
