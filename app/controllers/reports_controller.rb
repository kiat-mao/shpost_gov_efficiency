class ReportsController < ApplicationController

	def deliver_market_report
		unless request.get?
			init_result
		end
	end

  def deliver_market_report_export
  	init_result

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to :action => 'deliver_market_report'
    else
    	send_data(deliver_market_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-市场维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def deliver_unit_report
		unless request.get?
			init_result_unit
		end
	end

  def deliver_unit_report_export
  	init_result_unit

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to :action => 'deliver_unit_report'
    else
    	send_data(deliver_unit_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-投递维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  private
  	def deliver_market_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "二级行业名称:#{params["industry"]}"
	    sheet1[0,4] = "客户类别:#{params["btype"]}"
	    sheet1[0,8] = "客户:#{params["business"]}"
	    sheet1[1,0] = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"

	    0.upto(9) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(9) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{行业市场 收寄数 总妥投数 妥投率 三日妥投率 次日妥投率 未妥投总数 未妥投率 退回数 退回率}

	    count_row = 4

	    results.each do |k, v|
	      sheet1[count_row,0] = k
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,4] = v[3].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,5] = v[4].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,6] = v[5]
	      sheet1[count_row,7] = v[6].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,8] = v[7]
	      sheet1[count_row,9] = v[8].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(9) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end 
	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

  	def init_result
  		authorize! "report", "DeliverMarketReport"

	  	@results = nil
	  		  	
    	expresses = Express.get_filter_expresses(params)

      @results = Express.get_deliver_market_result(expresses)
  	end

  	def init_result_unit
  		authorize! "report", "DeliverUnitReport"

	  	@results = nil
	  		  	
    	expresses = Express.get_filter_expresses(params)

      @results = Express.get_deliver_unit_result(expresses)
  	end

  	def deliver_unit_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "二级行业名称:#{params["industry"]}"
	    sheet1[0,4] = "客户类别:#{params["btype"]}"
	    sheet1[0,8] = "客户:#{params["business"]}"
	    sheet1[1,0] = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"

	    0.upto(1) do |x|
	      sheet1.column(x).width = 20
	    end

	    2.upto(10) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(10) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{单位 网点 总邮件数 总妥投数 妥投率 三日妥投率 次日妥投率 未妥投总数 未妥投率 退回数 退回率}

	    count_row = 4

	    results.each do |k, v|
	      sheet1[count_row,0] = Unit.find(v[0]).name
	      sheet1[count_row,1] = Unit.find(k).name
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,5] = v[4].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,6] = v[5].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,7] = v[6]
	      sheet1[count_row,8] = v[7].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,9] = v[8]
	      sheet1[count_row,10] = v[9].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(10) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end 
	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

  	def to_date(time)
	    # date = Date.civil(time.split(/-|\//)[0].to_i,time.split(/-|\//)[1].to_i,time.split(/-|\//)[2].to_i)
	    time.to_time
	    # return date
	  end
end