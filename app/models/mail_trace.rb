class MailTrace < PkpDataRecord
  has_many :mail_trace_details
  # has_many :mail_trace_details

  def traces
    jdpt_traces = self.jdpt_traces
    if !jdpt_traces.blank?
      trace.sort{|x,y| x['opTime'] <=> y['opTime']}.map{|x| "#{x['opTime']}  #{x['opDesc']} \n"}.join
    else
      ""
    end
  end


  def jdpt_traces
    trace = [] 
    self.mail_trace_details.order(:created_at).each do |x|
      if !x.blank?
        trace += JSON.parse(x.traces.gsub("=>", ":"))
      end
    end
    trace
  end
end