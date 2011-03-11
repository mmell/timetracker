
Factory.sequence :position do |n|
  n
end

Factory.sequence :email do |n|
  "example#{n.to_s.rjust(4, '0')}@example.com"
end

Factory.define :person do |f|
  f.sequence(:name) { |n| "Person #{n.to_s.rjust(4, '0')}" }
  f.email { Factory.next(:email) }
end

Factory.define :project do |f|
  f.sequence(:name) { |n| "Project #{n.to_s.rjust(4, '0')}" }
end

Factory.define :project_position do |f|
end

Factory.define :current_activity do |f|
  f.started { 1.hour.ago }
end
