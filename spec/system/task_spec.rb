require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit new_task_path
        fill_in 'タスク名', with: 'new_task'
        fill_in '内容', with: 'new_content'
        click_on '登録'
        expect(page).to have_content 'new_task'
        expect(page).to have_content 'new_content'        
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task1 = FactoryBot.create(:task, title: 'task1', content: 'test', created_at: Time.current, user: user)
        task2 = FactoryBot.create(:task, title: 'task2', content: 'test', created_at: Time.current + 2.days, user: user)
        task3 = FactoryBot.create(:task, title: 'task3', content: 'test', created_at: Time.current + 1.days, user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list[0]).to have_content("task2")
        expect(task_list[1]).to have_content("task3")
        expect(task_list[2]).to have_content("task1")
      end
    end
    context 'タスク終了期限でソートされた場合' do
      it '終了期限の近いものが一番上に表示される' do
        task1 = Task.create(title: 'task1', content: 'test', limit: Time.current + 5.days, user: user)
        task2 = Task.create(title: 'task2', content: 'test', limit: Time.current + 10.days, user: user)
        task3 = Task.create(title: 'task3', content: 'test', limit: Time.current + 1.days, user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        click_on 'Limit'
        sleep(0.5)
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task3'
        expect(task_list[1]).to have_content 'task1'
        expect(task_list[2]).to have_content 'task2'
      end
    end
    context 'タイトルで検索した場合' do
      it '該当するものが表示される' do
        task = Task.create(title: 'yes', content: 'test', limit: '2023-03-03', status: '未着手', user: user)
        task = Task.create(title: 'no', content: 'test', limit: '2023-03-03', status: '未着手', user: user)
        task = Task.create(title: 'no', content: 'test', limit: '2023-03-03', status: '未着手', user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        fill_in 'task[title]', with: 'yes'
        click_on '検索'
        sleep(0.5)
        expect(page).to have_content 'yes'
        expect(page).not_to have_content 'no'
      end
    end
    context 'ステータスで検索した場合' do
      it '完全一致するものが表示される' do
        task = Task.create(title: 'yes', content: 'test', limit: '2023-03-03', status: '着手中', user: user)
        task = Task.create(title: 'no', content: 'test', limit: '2023-03-03', status: '未着手', user: user)
        task = Task.create(title: 'no', content: 'test', limit: '2023-03-03', status: '未着手', user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        select '着手中', from: 'task[status]'
        click_on '検索'
        sleep(0.5)
        expect(page).to have_content 'yes'
        expect(page).not_to have_content 'no'
      end
    end
    context 'タイトルとステータスの両方で検索した場合' do
      it 'タイトルが部分一致、ステータスが完全一致するものが表示される' do
        task = Task.create(title: 'yes', content: 'test1', limit: '2023-03-03', status: '未着手', user: user)
        task = Task.create(title: 'yes', content: 'test2', limit: '2023-03-03', status: '着手中', user: user)
        task = Task.create(title: 'no', content: 'test1', limit: '2023-03-03', status: '着手中', user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit tasks_path
        fill_in 'task[title]', with: 'yes'
        select '着手中', from: 'task[status]'
        click_on '検索'
        sleep(0.5)
        expect(page).to have_content 'test2'
        expect(page).not_to have_content 'test1'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, user: user)
        visit new_session_path
        fill_in 'session[email]', with: 'a@gmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'Log in'
        visit task_path(task)
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
      end
    end
  end
end