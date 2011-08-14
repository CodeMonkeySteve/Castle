UserNames = ['Zaphod Beeblebrox', 'Ford Prefect', 'Arthur Dent', 'Trisha McMillan', 'Marvin'].freeze

FactoryGirl.define do
  sequence(:name) { |n| UserNames[n % UserNames.size] + (n / UserNames.size).to_s }
  factory :user do
    name
    openid_url {  "http://#{name.downcase.gsub(' ','.')}.some-openid.com"  }
  end
end
