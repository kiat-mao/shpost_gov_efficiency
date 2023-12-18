class MailTraceHis < PkpDataRecordHis
  self.table_name = 'mail_traces'
  has_many :mail_trace_his_details, foreign_key: 'mail_trace_id'
  
  def traces
    jdpt_traces = self.jdpt_traces
    if !jdpt_traces.blank?
      jdpt_traces.sort{|x,y| x['opTime'] <=> y['opTime']}.map{|x| "#{x['opTime']}  #{x['opDesc']}, 操作代码: #{x['opCode']}, 操作名称: #{x['opName']}, 操作人: #{x['operatorName']}, 操作单位: #{x['opOrgName']} \n"}.uniq.join
    else
      ""
    end
  end


  def jdpt_traces
    trace = [] 
    self.mail_trace_his_details.order(:created_at).each do |x|
      if !x.blank?
        trace += JSON.parse(x.traces.gsub("=>", ":"))
      end
    end
    trace.uniq
  end
end