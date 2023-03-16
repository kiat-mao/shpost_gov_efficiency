class ReportsController < ApplicationController

	def deliver_market_report
		@is_search = nil
		@search_time = "by_d"
		@is_court = false
		@is_market = true
		@is_monitor = false
		@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
    	# byebug
    	send_data(deliver_market_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-市场维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def deliver_unit_report
  	@is_search = nil
  	@search_time = "by_d"
  	@is_court = false
  	@is_market = false
  	@is_monitor = false
  	@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
  	@day = params[:day]
  	@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
		@day = params[:day]
		@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
		@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
  	@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
  	@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
		@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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
  	@bf_free_tax = false
  	@is_receipt = true
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

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

  def deliver_province_report
  	@is_search = nil
  	@search_time = "by_d"
  	@is_court = nil
  	@is_market = nil
  	@is_monitor = false
  	@is_province = true
  	@bf_free_tax = false
		if !params[:checkbox].blank? && (params[:checkbox][:bf_free_tax].eql?"1")
			@bf_free_tax = true
		end

		unless request.get?
			init_result_province_city
			@is_search = "yes"
			@search_time = params[:search_time].blank? ? "by_d" : params[:search_time]
		end
  end

  def deliver_city_report
		init_result_province_city
	end

	def deliver_prov_city_report_export
		init_result_province_city

  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(province_city_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表(省市维度)_#{Time.now.strftime("%Y%m%d")}.xls")  
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
	    deliver_date_range = ""
	    #总列数,params[:delivered_days_show].to_i-1)*2+1是几日妥投率，13是其余固定项
	    if params[:is_monitor].eql?"true"
	    	cols = 13
	    else
	    	cols = (params[:delivered_days_show].to_i-1)*2+1+13
    	end   

	    0.upto(6) do |x|
	    	sheet1.row(x).default_format = filter
	    end 
	    sheet1[0,0] = "寄递范围:#{params["destination"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"    
	    sheet1[1,0] = "产品类型:#{Report.get_export_product_name(params["product"])}"
	    sheet1[1,2] = "客户类别:#{params["btype"]}"
	    sheet1[1,6] = "二级行业名称:#{params[:industry]}"
	    sheet1[2,0] = "按收寄时间点:#{params["posting_hour_start"]} - #{params["posting_hour_end"]}"
	    sheet1[2,2] = "运输方式:#{Report.get_transfer_type_name(params["transfer_type"])}"
	    if !params[:is_monitor].eql?"true"
	    	sheet1[2,6] = "展示几日妥投率:#{params[:delivered_days_show]}"
	    end
	    sheet1[3,0] = "是否保税仓邮件:#{(!params["bf_free_tax"].blank? && (params["bf_free_tax"].eql?'1')) ? '是' : ''}"
	    
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[4,0] = date_range

	    	deliver_date_range = "妥投日期：#{params["delivered_date_start"]} - #{params["delivered_date_end"]}"
	    	sheet1[5,0] = deliver_date_range
	    end


	    0.upto(cols-1) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(cols-1) do |x|
	      sheet1.row(7).set_format(x, title)
	    end
	    sheet1.row(7).concat %w{客户类别 收寄数 总妥投数 本人收数 他人收数 单位/快递柜收数 妥投率}

	    i = 0.0
	    c = 7
	    while i <= params[:delivered_days_show].to_f-1
	    	sheet1[7, c] = "#{Report::DELIVERED_DAYS_NAME[i]}妥投率"
	    	c += 1
	    	i += 0.5
	    end

	    sheet1.row(7).concat %w{未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 8

	    results.each do |k, v|
	      sheet1[count_row,0] = k
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3]
	      sheet1[count_row,5] = v[4]
	      sheet1[count_row,6] = v[5].to_s(:rounded, precision: 2)+"%"
	      j = 0.0
	      col = 7
	      while j <= params[:delivered_days_show].to_f-1
	      	sheet1[count_row,col] = v[12][j][1].to_s(:rounded, precision: 2)+"%"
	      	col += 1
	      	j += 0.5
        end

	      sheet1[count_row,col] = v[6]
	      sheet1[count_row,col+1] = v[10]
	      sheet1[count_row,col+2] = v[11]
	      sheet1[count_row,col+3] = v[7].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,col+4] = v[8]
	      sheet1[count_row,col+5] = v[9].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(cols-7) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    (cols-6).upto(cols-3) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    (cols-2).upto(cols-1) do |i|
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
	  		  	
    	expresses = Report.get_filter_expresses(params).accessible_by(current_ability)

      @results = Report.get_deliver_market_result(expresses, params, current_user)
      # byebug
  	end

  	def init_result_unit
  		authorize! "report", "DeliverUnitReport"

	  	@results = nil
	  	
	  	expresses = Report.get_filter_expresses(params).accessible_by(current_ability)

      @results = Report.get_deliver_unit_result(expresses, params)
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
	    deliver_date_range = ""
	    #总列数,params[:delivered_days_show].to_i-1)*2+1是几日妥投率，14是其余固定项
	    if params[:is_monitor].eql?"true"
	    	cols = 15
	    else
      	cols = (params[:delivered_days_show].to_i-1)*2+1+15 
      end

	    0.upto(6) do |x|
	    	sheet1.row(x).default_format = filter
	    end 
	    	    
	    sheet1[0,0] = "寄递范围:#{params["destination"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"
	    sheet1[0,6] = "区分公司:#{lv2_unit}"
	    sheet1[1,0] = "产品类型:#{Report.get_export_product_name(params["product"])}"	    
	    sheet1[1,2] = "客户类别:#{params["btype"]}"
	    sheet1[1,6] = "二级行业名称:#{params["industry"]}"
	    sheet1[2,0] = "按收寄时间点:#{params["posting_hour_start"]} - #{params["posting_hour_end"]}"
	    sheet1[2,2] = "运输方式:#{Report.get_transfer_type_name(params["transfer_type"])}"
	    if !params[:is_monitor].eql?"true"
	    	sheet1[2,6] = "展示几日妥投率:#{params[:delivered_days_show]}"
	    end
	    sheet1[3,0] = "是否保税仓邮件:#{(!params["bf_free_tax"].blank? && (params["bf_free_tax"].eql?'1')) ? '是' : ''}"

	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[4,0] = date_range

	    	deliver_date_range = "妥投日期：#{params["delivered_date_start"]} - #{params["delivered_date_end"]}"
	    	sheet1[5,0] = deliver_date_range
	    end

	    0.upto(1) do |x|
	      sheet1.column(x).width = 20
	    end

	    2.upto(cols-1) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(cols-1) do |x|
	      sheet1.row(7).set_format(x, title)
	    end
	    sheet1.row(7).concat %w{单位 网点 总邮件数 总妥投数 本人收数 他人收数 单位/快递柜收数 妥投率}

	    i = 0.0
      c = 8
      while i <= params[:delivered_days_show].to_f-1
        sheet1[7, c] = "#{Report::DELIVERED_DAYS_NAME[i]}妥投率"
        c += 1
        i += 0.5
      end

	    sheet1.row(7).concat %w{未及时妥投数 未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 8
	    last_pid = nil

	    results.each do |k, v|
	      sheet1[count_row,0] =  (k.blank? || (k.eql?"合计")) ? "" : ((v[0] == last_pid) ? "" : v[14])
	      sheet1[count_row,1] = k.blank? ? "其他" : ((k.eql?"合计") ? k : v[13])
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3]
	      sheet1[count_row,5] = v[4]
	      sheet1[count_row,6] = v[5]
	      sheet1[count_row,7] = v[6].to_s(:rounded, precision: 2)+"%"
	      j = 0.0
        col = 8
        while j <= params[:delivered_days_show].to_f-1
          sheet1[count_row,col] = v[15][j][1].to_s(:rounded, precision: 2)+"%"
          col += 1
          j += 0.5
        end

        sheet1[count_row,col] = v[16]
	      sheet1[count_row,col+1] = v[7]
	      sheet1[count_row,col+2] = v[11]
	      sheet1[count_row,col+3] = v[12]
	      sheet1[count_row,col+4] = v[8].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,col+5] = v[9]
	      sheet1[count_row,col+6] = v[10].to_s(:rounded, precision: 2)+"%"
	      last_pid = v[0]
	      
	      0.upto(cols-8) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end 
		    (cols-7).upto(cols-3) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    (cols-2).upto(cols-1) do |i|
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
	  		  	
    	expresses = Report.get_filter_expresses(params).accessible_by(current_ability)

      @results = Report.get_business_result(expresses, params)
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
	    deliver_date_range = ""
	    #总列数,params[:delivered_days_show].to_i-1)*2+1是几日妥投率，13是其余固定项
	    if params[:is_monitor].eql?"true"
	    	cols = 13
	    else
      	cols = (params[:delivered_days_show].to_i-1)*2+1+13   
      end

	    0.upto(6) do |x|
	    	sheet1.row(x).default_format = filter
	    end  

	    sheet1[0,0] = "寄递范围:#{params["destination"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"
	    sheet1[1,0] = "产品类型:#{Report.get_export_product_name(params["product"])}"	 
	    sheet1[1,2] = "客户类别:#{params["detail_btype"]}"
	    sheet1[1,6] = "二级行业名称:#{params[:industry]}"
	    sheet1[2,0] = "按收寄时间点:#{params["posting_hour_start"]} - #{params["posting_hour_end"]}"
	    sheet1[2,2] = "运输方式:#{Report.get_transfer_type_name(params["transfer_type"])}"
	    if !params[:is_monitor].eql?"true"
	    	sheet1[2,6] = "展示几日妥投率:#{params[:delivered_days_show]}"
	    end
	    sheet1[3,0] = "是否保税仓邮件:#{(!params["bf_free_tax"].blank? && (params["bf_free_tax"].eql?'1')) ? '是' : ''}"
	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[4,0] = date_range

	    	deliver_date_range = "妥投日期：#{params["delivered_date_start"]} - #{params["delivered_date_end"]}"
	    	sheet1[5,0] = deliver_date_range
	    end

	    0.upto(cols-1) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(cols-1) do |x|
	      sheet1.row(7).set_format(x, title)
	    end
	    sheet1.row(7).concat %w{客户 收寄数 总妥投数 本人收数 他人收数 单位/快递柜收数 妥投率}
	    i = 0.0
      c = 7
      while i <= params[:delivered_days_show].to_f-1
        sheet1[7, c] = "#{Report::DELIVERED_DAYS_NAME[i]}妥投率"
        c += 1
        i += 0.5
      end
	    sheet1.row(7).concat %w{未妥投总数 在途中数 投递端数 未妥投率 退回数 退回率}

	    count_row = 8

	    results.each do |k, v|
	      sheet1[count_row,0] = (k.eql?"合计") ? k : k.name
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3]
	      sheet1[count_row,5] = v[4]
	      sheet1[count_row,6] = v[5].to_s(:rounded, precision: 2)+"%"
	      j = 0.0
        col = 7
        while j <= params[:delivered_days_show].to_f-1
          sheet1[count_row,col] = v[12][j][1].to_s(:rounded, precision: 2)+"%"
          col += 1
          j += 0.5
        end
	      sheet1[count_row,col] = v[6]
        sheet1[count_row,col+1] = v[10]
        sheet1[count_row,col+2] = v[11]
        sheet1[count_row,col+3] = v[7].to_s(:rounded, precision: 2)+"%"
        sheet1[count_row,col+4] = v[8]
        sheet1[count_row,col+5] = v[9].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(cols-7) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    (cols-6).upto(cols-3) do |i|
		      sheet1.row(count_row).set_format(i, red)
		    end 
		    (cols-2).upto(cols-1) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end  
	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

	  def init_result_receipt
	  	@results = nil
	  		  	
    	expresses = Report.get_filter_expresses(params).accessible_by(current_ability)

      @results = Report.get_receipt_result(expresses, params)
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
	    deliver_date_range = ""

	    0.upto(4) do |x|
	    	sheet1.row(x).default_format = filter
	    end  
	    
	    sheet1[0,0] = "寄递范围:#{params["destination"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"	    
	    sheet1[1,0] = "产品类型:#{Report.get_export_product_name(params["product"])}"	 
	    sheet1[1,2] = "客户类别:#{params["btype"]}"
	    sheet1[1,6] = "二级行业名称:#{params["industry"]}"
	    sheet1[2,0] = "按收寄时间点:#{params["posting_hour_start"]} - #{params["posting_hour_end"]}"
	    sheet1[2,2] = "运输方式:#{Report.get_transfer_type_name(params["transfer_type"])}"
	    sheet1[3,0] = "是否保税仓邮件:#{(!params["bf_free_tax"].blank? && (params["bf_free_tax"].eql?'1')) ? '是' : ''}"

	    if !params[:is_monitor].eql?"true"
	    	if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
	    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
        	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
	    		date_range = "收寄范围：#{start_date} - #{end_date}"
	    	else
	    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
	    	end
	    	sheet1[4,0] = date_range

	    	deliver_date_range = "妥投日期：#{params["delivered_date_start"]} - #{params["delivered_date_end"]}"
	    	sheet1[5,0] = deliver_date_range
	    end
	    
	    0.upto(10) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(10) do |x|
	      sheet1.row(7).set_format(x, title)
	    end
	    sheet1.row(7).concat %w{客户名称 正向邮件总收寄数 正向邮件妥投数 正向邮件未妥投数 正向邮件妥投返单邮件收寄数 正向邮件妥投返单邮件未收寄数 返单邮件返回数(妥投数) 返单邮件未返回数(未妥投) 正向邮件退回数 正向邮件未妥投返单邮件已收寄数 返单邮件返单率%}

	    count_row = 8

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
	      
	      0.upto(8) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    sheet1.row(count_row).set_format(9, red)
		    sheet1.row(count_row).set_format(10, body)
		    	      
	      count_row += 1
	    end

	    book.write xls_report  
	    xls_report.string

	  end

	  def init_result_province_city
	  	@results = nil
	  		  	
    	expresses = Report.get_filter_expresses(params).accessible_by(current_ability)

      @results = Report.get_province_city_result(expresses, params)
    end

    def province_city_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 12, :border => :thin, :align => :center
	    filter = Spreadsheet::Format.new :size => 11
	    body = Spreadsheet::Format.new :size => 11, :border => :thin, :align => :center
	    red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center
	    date_range = ""
	    deliver_date_range = ""
	    #总列数,params[:delivered_days_show].to_i-1)*4+2是几日妥投率，12是其余固定项
      cols = (params[:delivered_days_show].to_i-1)*4+2+12  

	    0.upto(5) do |x|
	    	sheet1.row(x).default_format = filter
	    end    
	    
	    sheet1[0,0] = "寄递范围:#{params["destination"]}"
	    sheet1[0,2] = "客户:#{params["business"]}"    
	    sheet1[1,0] = "产品类型:#{Report.get_export_product_name(params["product"])}"	
	    sheet1[1,2] = "客户类别:#{params["btype"]}"
	    sheet1[1,6] = "二级行业名称:#{params["industry"]}"
	    sheet1[2,0] = "按收寄时间点:#{params["posting_hour_start"]} - #{params["posting_hour_end"]}"
	    sheet1[2,2] = "集散中心:#{Report.get_distributive_center_name(params["distributive_center_no"])}"
	    sheet1[2,6] = "运输方式:#{Report.get_transfer_type_name(params["transfer_type"])}"
	    sheet1[2,8] = "展示几日妥投率:#{params[:delivered_days_show]}"
	    sheet1[3,0] = "是否保税仓邮件:#{(!params["bf_free_tax"].blank? && (params["bf_free_tax"].eql?'1')) ? '是' : ''}"
	    if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
    		start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month.strftime("%Y-%m-%d")
      	end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month.strftime("%Y-%m-%d")
    		date_range = "收寄范围：#{start_date} - #{end_date}"
    	else
    		date_range = "收寄范围：#{params["posting_date_start"]} - #{params["posting_date_end"]}"
    	end
    	sheet1[4,0] = date_range

    	deliver_date_range = "妥投日期：#{params["delivered_date_start"]} - #{params["delivered_date_end"]}"
    	sheet1[5,0] = deliver_date_range
    	
	    
	    0.upto(cols-1) do |x|
	      sheet1.column(x).width = 16
	    end

	    0.upto(cols-1) do |x|
	      sheet1.row(7).set_format(x, title)
	    end
	    sheet1.row(7).concat %w{收寄省 收寄数 总妥投数 本人收数 他人收数 单位/快递柜收数 妥投率 平均妥投天数} 
	    i = 0.0
      c = 8
      while i <= params[:delivered_days_show].to_f-1
        sheet1[7, c] = "#{Report::DELIVERED_DAYS_NAME[i]}妥投率"
        sheet1[7, c+1] = "#{Report::DELIVERED_DAYS_NAME[i]}妥投总数"
        c += 2
        i += 0.5
      end
      sheet1.row(7).concat %w{未妥投总数 未妥投率 退回数 退回率}
	    
	    count_row = 8

	    results.each do |k, v|
	      sheet1[count_row,0] = k[0].blank? ? "其他" : ((k[0].eql?"合计") ? "合计" : (k[1].blank? ? k[0] : k[1]))
	      sheet1[count_row,1] = v[0]
	      sheet1[count_row,2] = v[1]
	      sheet1[count_row,3] = v[2]
	      sheet1[count_row,4] = v[3]
	      sheet1[count_row,5] = v[4]
	      sheet1[count_row,6] = v[5].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,7] = v[6].to_s(:rounded, precision: 2)

	      j = 0.0
        col = 8
        while j <= params[:delivered_days_show].to_f-1
          sheet1[count_row,col] = v[11][j][1].to_s(:rounded, precision: 2)+"%"
          sheet1[count_row,col+1] = v[11][j][0]
          col += 2
          j += 0.5
        end
	   
	      sheet1[count_row,col] = v[7]
	      sheet1[count_row,col+1] = v[8].to_s(:rounded, precision: 2)+"%"
	      sheet1[count_row,col+2] = v[9]
	      sheet1[count_row,col+3] = v[10].to_s(:rounded, precision: 2)+"%"
	      
	      0.upto(cols-5) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    (cols-4).upto(cols-3) do |i|
		    	sheet1.row(count_row).set_format(i, red)
		    end
		    (cols-2).upto(cols-1) do |i|
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