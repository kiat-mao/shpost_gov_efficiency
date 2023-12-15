class MailTraceHisDetail < PkpDataRecordHis
  self.table_name = 'mail_trace_details'
  belongs_to :mail_trace_his, foreign_key: 'mail_trace_id'
end