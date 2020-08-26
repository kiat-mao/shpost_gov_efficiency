class ReportsController < ApplicationController

	def deliver_market_report
		@is_search = nil
		@search_time = "by_d"
		@is_court = false
		@is_market = true
		@is_monitor = false

		unless request.get?
			init_result
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end

		# respond_to do |format|
  #     format.js 
  #   end
	end

  def deliver_market_report_export
  	init_result

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(deliver_market_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-市场维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def deliver_unit_report
  	@is_search = nil
  	@search_time = "by_d"
  	@is_court = false
  	@is_market = false
  	@is_monitor = false

		unless request.get?
			init_result_unit
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end
	
  end

  def deliver_unit_report_export
  	init_result_unit

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(deliver_unit_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-投递维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def deliver_market_monitor
  	@is_search = nil
  	@is_court = false
  	@is_market = true
  	@is_monitor = true

  	unless request.get?
			init_result
			@is_search = "yes"
		end
	end

	def deliver_unit_monitor
		@is_search = nil
		@is_court = false
		@is_market = false
		@is_monitor = true

		unless request.get?
			init_result_unit
			@is_search = "yes"
		end
	end

	def court_deliver_market_report
		@is_search = nil
		@search_time = "by_d"
		@is_court = true
		@is_market = true
		@is_monitor = false

		unless request.get?
			init_result
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end
	end

	def court_deliver_unit_report
  	@is_search = nil
  	@search_time = "by_d"
  	@is_court = true
  	@is_market = false
  	@is_monitor = false

		unless request.get?
			init_result_unit
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end
	end

	def court_deliver_market_monitor
  	@is_search = nil
  	@is_court = true
  	@is_market = true
  	@is_monitor = true

  	unless request.get?
			init_result
			@is_search = "yes"
		end
	end

	def court_deliver_unit_monitor
		@is_search = nil
		@is_court = true
		@is_market = false
		@is_monitor = true

		unless request.get?
			init_result_unit
			@is_search = "yes"
		end
	end

	def business_market_report
		init_result_business
	end

	def business_market_report_export
  	init_result_business

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(business_market_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-市场维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def receipt_report
  	@is_search = nil
  	@search_time = "by_d"
  	@is_court = nil
  	@is_market = nil
  	@is_monitor = false

		unless request.get?
			init_result_receipt
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end
  end

  def receipt_report_export
  	init_result_receipt

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(receipt_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "返单用户监控报表_#{Time.now.strftime("%Y%m%d")}.xls")  
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
	    red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center
	    date_range = ""

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "二级行业名称:#{params["industry"]}"
	    sheet1[0,2] = "客户类别:#{params["btype"]}"
	    sheet1[0,4] = "客户:#{params["business"]}"
	    sheet1[0,6] = "寄递范围:#{params["destination"]}"
	    sheet1[0,8] = "产品类型:#{Express::BASE_PRODUCT_NAME[params["product"].to_sym]}"
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[1,0] = date_range
	    end

	    0.upto(12) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(12) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{行业市场 收寄数 总妥投数 妥投率 三日妥投率 次日妥投率 五日妥投率 未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 4

	    results.each do |k, v|
	      sheet1[count_row,0] = k
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,4] = v[3].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,5] = v[4].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,6] = v[9].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,7] = v[5]
	      sheet1[count_row,8] = v[10]
	      sheet1[count_row,9] = v[11]
	      sheet1[count_row,10] = v[6].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,11] = v[7]
	      sheet1[count_row,12] = v[8].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(6) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    7.upto(10) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    11.upto(12) do |i|
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
	  		  	
    	expresses = Express.get_filter_expresses(params).accessible_by(current_ability)

      @results = Express.get_deliver_market_result(expresses, params)
  	end

  	def init_result_unit
  		authorize! "report", "DeliverUnitReport"

	  	@results = nil
	  		  	
    	expresses = Express.get_filter_expresses(params).accessible_by(current_ability)

      @results = Express.get_deliver_unit_result(expresses)
  	end

  	def deliver_unit_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center
	    red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center

	    lv2_unit = params["lv2_unit"].blank? ? "" : Unit.find(params["lv2_unit"].to_i).name
	    date_range = ""

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "二级行业名称:#{params["industry"]}"
	    sheet1[0,2] = "客户类别:#{params["btype"]}"
	    sheet1[0,4] = "客户:#{params["business"]}"
	    sheet1[0,6] = "寄递范围:#{params["destination"]}"
	    sheet1[0,8] = "区分公司:#{lv2_unit}"
	    sheet1[0,10] = "产品类型:#{Express::BASE_PRODUCT_NAME[params["product"].to_sym]}"
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[1,0] = date_range
	    end

	    0.upto(1) do |x|
	      sheet1.column(x).width = 20
	    end

	    2.upto(13) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(13) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{单位 网点 总邮件数 总妥投数 妥投率 三日妥投率 次日妥投率 五日妥投率 未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 4
	    last_pid = nil

	    results.each do |k, v|
	      sheet1[count_row,0] =  (k.blank? || (k.eql?"合计")) ? "" : ((v[0] == last_pid) ? "" : (k.parent_id.blank? ? "" : k.parent_unit.name))
	      sheet1[count_row,1] = k.blank? ? "其他" : ((k.eql?"合计") ? k : k.name)
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,5] = v[4].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,6] = v[5].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,7] = v[10].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,8] = v[6]
	      sheet1[count_row,9] = v[11]
	      sheet1[count_row,10] = v[12]
	      sheet1[count_row,11] = v[7].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,12] = v[8]
	      sheet1[count_row,13] = v[9].to_s(:rounded, precision: 2)+"%"
	      last_pid = v[0]
	      
	      0.upto(7) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end 
		    8.upto(11) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    12.upto(13) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end 

	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

	  def init_result_business
  		authorize! "report", "DeliverMarketReport"

	  	@results = nil
	  		  	
    	expresses = Express.get_filter_expresses(params).accessible_by(current_ability)

      @results = Express.get_business_result(expresses, params)
    end

  	def business_market_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center
	    red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center
	    date_range = ""

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "客户类别:#{params["detail_btype"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"
	    sheet1[0,4] = "寄递范围:#{params["destination"]}"
	    sheet1[0,6] = "产品类型:#{Express::BASE_PRODUCT_NAME[params["product"].to_sym]}"
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[1,0] = date_range
	    end

	    0.upto(12) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(12) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{客户 收寄数 总妥投数 妥投率 三日妥投率 次日妥投率 五日妥投率 未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 4

	    results.each do |k, v|
	      sheet1[count_row,0] = (k.eql?"合计") ? k : k.name
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,4] = v[3].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,5] = v[4].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,6] = v[9].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,7] = v[5]
	      sheet1[count_row,8] = v[10]
	      sheet1[count_row,9] = v[11]
	      sheet1[count_row,10] = v[6].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,11] = v[7]
	      sheet1[count_row,12] = v[8].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(6) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    7.upto(10) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    11.upto(12) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end  
	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

	  def init_result_receipt
	  	@results = nil
	  		  	
    	expresses = Express.get_filter_expresses(params).accessible_by(current_ability)

      @results = Express.get_receipt_result(expresses, params)
    end

    def receipt_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center
	    red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center
	    date_range = ""

	    sheet1.row(0).default_format = filter
	    sheet1.row(1).default_format = filter
	    sheet1[0,0] = "二级行业名称:#{params["industry"]}"
	    sheet1[0,2] = "客户类别:#{params["btype"]}"
	    sheet1[0,4] = "客户:#{params["business"]}"
	    sheet1[0,6] = "寄递范围:#{params["destination"]}"
	    sheet1[0,8] = "产品类型:#{Express::BASE_PRODUCT_NAME[params["product"].to_sym]}"
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[1,0] = date_range
	    end

	    0.upto(10) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(10) do |x|
	      sheet1.row(3).set_format(x, title)
	    end
	    sheet1.row(3).concat %w{客户名称 正向邮件总收寄数 正向邮件妥投数 正向邮件未妥投数 正向邮件妥投返单邮件收寄数 正向邮件妥投返单邮件未收寄数 返单邮件返回数(妥投数) 返单邮件未返回数(未妥投) 正向邮件退回数 正向邮件未妥投返单邮件已收寄数 返单邮件返单率%}

	    count_row = 4

	    results.each do |k, v|
	      sheet1[count_row,0] = (k.eql?"合计") ? k : k.name
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3]
	      sheet1[count_row,5] = v[4]
	      sheet1[count_row,6] = v[5]
	      sheet1[count_row,7] = v[6]
	      sheet1[count_row,8] = v[7]
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