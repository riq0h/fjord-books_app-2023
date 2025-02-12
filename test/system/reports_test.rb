# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'
    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text @report.title
    assert_text @report.content
    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'
    new_title = 'タイトルを変更'
    new_content = '内容を変更'
    fill_in 'タイトル', with: new_title
    fill_in '内容', with: new_content
    click_on '更新する'
    assert_text '日報が更新されました。'
    assert_text new_title
    assert_text new_content
    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除'
    assert_text '日報が削除されました。'
    assert_no_text @report.title
  end
end
