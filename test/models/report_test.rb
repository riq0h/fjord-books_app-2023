# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    alice = users(:alice)
    bob = users(:bob)
    report = Report.new(user: alice)
    assert report.editable?(alice)
    assert_not report.editable?(bob)
  end

  test '#created_on' do
    datetime = DateTime.new(1993, 2, 24, 12, 30, 45)
    date = Date.new(1993, 2, 24)
    report = Report.new(created_at: datetime)
    assert_equal date, report.created_on
  end

  test 'save_mentions when create report' do
    mentioned_report = reports(:report_id1)
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'http://localhost:3000/reports/1を読んだ'
    mentioning_report.save
    assert ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report.id)
  end

  test 'save_mentions when update report' do
    mentioned_report1 = reports(:report_id1)
    mentioned_report2 = reports(:report_id2)
    mentioning_report = reports(:report_id3)

    # 既存のmentionを作成
    mentioning_report.update(content: 'http://localhost:3000/reports/1を読んだ')

    # 新しいmentionを追加し、既存のmentionを維持
    mentioning_report.update(content: 'http://localhost:3000/reports/1とhttp://localhost:3000/reports/2を読んだ')
    assert ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report1.id)
    assert ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report2.id)

    # 既存のmentionを削除
    mentioning_report.update(content: 'http://localhost:3000/reports/2のみ読んだ')
    assert_not ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report1.id)
    assert ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report2.id)
  end

  test 'save_mentions when destroy report' do
    mentioning_report = reports(:report_id2)
    mentioned_report = reports(:report_id1)
    mentioning_report.update(content: 'http://localhost:3000/reports/1を読んだ')
    assert ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report.id)
    mentioning_report.destroy
    assert_not ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioned_report.id)
  end

  test 'save_mentions case mentioning not exist report' do
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'http://localhost:3000/reports/999を読んだ'
    mentioning_report.save
    assert_not ReportMention.exists?(mentioning_id: mentioning_report.id)
  end

  test 'save_mentions case mentioning self report' do
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'めちゃくちゃhttp://localhost:3000/reports/2を読んだ'
    mentioning_report.save
    assert_not ReportMention.exists?(mentioning_id: mentioning_report.id, mentioned_id: mentioning_report.id)
  end
end
