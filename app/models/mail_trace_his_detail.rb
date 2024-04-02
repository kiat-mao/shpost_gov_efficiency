class MailTraceHisDetail < PkpDataRecordHis
  # self.table_name = 'mail_trace_details'
  belongs_to :mail_trace_his, foreign_key: 'mail_trace_id'

  # 根据年份查询不同的明细表
  def self.get_detail_table_name(year)
    current_year = Date.current.year
    if year.to_i == current_year
      "mail_trace_details"
    else
      "mail_trace_details_#{year}"
    end
  end

  # 根据不同的年份查询邮件明细
  def self.get_details_by_year(year, mail_trace_id)
    self.table_name = self.get_detail_table_name(year)
    MailTraceHisDetail.where(mail_trace_id: mail_trace_id).order(:created_at)
  end
end