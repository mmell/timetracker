FactoryGirl.define do
  sequence :position do |n|
    n
  end

  sequence :email do |n|
    "example#{n.to_s.rjust(4, '0')}@example.com"
  end

  factory :person do |f|
    f.sequence(:name) { |n| "Person #{n.to_s.rjust(4, '0')}" }
    f.email { FactoryGirl.generate :email }
  end

  factory :project do |f|
    f.sequence(:name) { |n| "Project #{n.to_s.rjust(4, '0')}" }
  end

  factory :project_position do |f|
  end

  factory :current_activity do |f|
    f.started { 1.hour.ago }
  end

end
