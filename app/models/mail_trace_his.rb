class MailTraceHis < PkpDataRecordHis
  # self.table_name = 'mail_traces'
  has_many :mail_trace_his_details, foreign_key: 'mail_trace_id'
  
  def self.traces(year, id)
    jdpt_traces = self.jdpt_traces(year, id)
    if !jdpt_traces.blank?
      jdpt_traces.sort{|x,y| x['opTime'] <=> y['opTime']}.map{|x| "#{x['opTime']}  #{x['opDesc']}, 操作代码: #{x['opCode']}, 操作名称: #{x['opName']}, 操作人: #{x['operatorName']}, 操作单位: #{x['opOrgName']} \n"}.uniq.join
    else
      ""
    end
  end


  def self.jdpt_traces(year, id)
    trace = [] 
    details = MailTraceHisDetail.get_details_by_year(year, id)

    details.each do |x|
      if !x.blank?
        trace += JSON.parse(x["traces"].gsub("=>", ":"))
      end
    end
    trace.uniq
  end

  # 历史轨迹查询邮件日期下拉框选项
  def self.select_year
    select_years = []
    current_year = Date.current.year

    select_years << "2023及以前"
    i = 2024
    while i<=current_year
      select_years << i.to_s
      i += 1
    end
    return select_years
  end

  # 根据年份查询不同的表
  def self.get_table_name(year)
    current_year = Date.current.year
    if year.to_i == current_year
      "mail_traces"
    else
      "mail_traces_#{year}"
    end
  end

  

  # 根据不同的年份查询邮件
  def self.find_by_year(year, mail_no)
    self.table_name = self.get_table_name(year)
    MailTraceHis.find_by(mail_no: mail_no)
  end

end