FactoryBot.define do
  factory :task do 
    title { 'test_title' }
    content { 'test_content' }
    limit { '2023/3/20' }
    status{ '着手中' }
  end

  factory :second_task, class: Task do
    title { 'test_title2' }
    content { 'test_content2' }
    limit {'2023-03-25'}
    status {'未着手'}
  end
end
