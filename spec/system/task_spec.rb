require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
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
        task = FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
        task = FactoryBot.create(:second_task)
        visit tasks_path
        expect(page).to have_content 'test_title_2'
        expect(page).to have_content 'test_content_2'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
      end
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:second_task)
        visit task_path(task)
        expect(page).to have_content 'test_title_2'
        expect(page).to have_content 'test_content_2'
      end
    end
  end
end