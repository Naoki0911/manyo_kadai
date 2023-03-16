FactoryBot.define do
  factory :task do 
    title { 'test_title' }
    content { 'test_content' }
    limit { '2023/3/20' }
  end
end
