class ReportsController < ApplicationController

	def deliver_market_report
		@is_search = nil
		@search_time = "by_d"
		@is_court = false
		@is_market = true
		@is_monitor = false
		@bf_free_tax = false
		@undelivered_nextday = false

		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
    	send_data(deliver_unit_report_xls_content_for(params, @results, @parent_unit_results),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-投递维度_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def deliver_market_monitor
  	@is_search = nil
  	@is_court = false
  	@is_market = true
  	@is_monitor = true
  	@day = params[:day]
  	@bf_free_tax = false
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
		@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
		@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
		@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end

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
  	@undelivered_nextday = false
		
		if !params[:checkbox].blank? && (params[:checkbox][:undelivered_nextday].eql?"1")
			@undelivered_nextday = true
		end
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

  def international_express_report
		unless request.get?
			@is_search = "yes"
			@country_id = params[:country_id].to_i

	    init_international_result
		end
	end

  def international_express_report_export
  	@results = init_international_result
  	
  	if @results.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	send_data(international_express_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "VIP客户时效跟踪报表_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

	# 中免同城投递汇总表（二级单位维度）
  def zm_deliver_report
  	@is_search = nil
  	@results = nil
  	
		unless request.get?
	  	if !params[:posting_date_start].blank? && !params[:posting_date_end].blank? && ((params[:posting_date_end].to_date - params[:posting_date_start].to_date) < 7)
	  		@is_search = "yes"
	  		@posting_date_start = params[:posting_date_start].blank? ? Date.yesterday : params[:posting_date_start].to_date
				@posting_date_end = params[:posting_date_end].blank? ? Date.today : params[:posting_date_end].to_date+1.day
  		
		  	expresses = Express.left_outer_joins(:business).where("businesses.code = ? and expresses.receiver_province_no = ? and expresses.is_arrive_sub = ? and posting_date  >= ? and posting_date < ?", "1100207488562", "310000", true, @posting_date_start, @posting_date_end)

		  	if expresses.blank?
		    	flash[:alert] = "无数据"
		    else	  	
		    	@results = Report.get_zm_deliver_result(expresses)
		    end
		  else
		  	flash[:alert] = "起止日期不能超过7天 "
	  	end
		end
	end

	# 中免同城投递汇总表（二级单位维度）导出
	def zm_deliver_report_export
		if !params[:posting_date_start].blank? && !params[:posting_date_end].blank? && ((params[:posting_date_end].to_date - params[:posting_date_start].to_date) < 7)
			@posting_date_start = params[:posting_date_start].blank? ? Date.yesterday : params[:posting_date_start].to_date
			@posting_date_end = params[:posting_date_end].blank? ? Date.today : params[:posting_date_end].to_date+1.day

	  	expresses = Express.left_outer_joins(:business).where("businesses.code = ? and expresses.receiver_province_no = ? and expresses.is_arrive_sub = ? and posting_date  >= ? and posting_date < ?", "1100207488562", "310000", true, @posting_date_start, @posting_date_end).order("expresses.express_no")

	  	if expresses.blank?
	    	flash[:alert] = "无数据"
	    else	  	
	    	@results = Report.get_zm_deliver_result(expresses)
	    	send_data(zm_deliver_report_xls_content_for(params, @results, expresses),:type => "text/excel;charset=utf-8; header=present",:filename => "中免同城投递汇总表_#{Time.now.strftime("%Y%m%d")}.xls") 
	    end
	  else
	  	flash[:alert] = "起止日期不能超过7天"
  	end
  end

  def zm_deliver_report_xls_content_for(params, results, expresses)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "中免同城投递汇总表" 
    sheet2 = book.create_worksheet :name => "明细（总计）"  
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    # 中免同城投递汇总表
    sheet1[0,0] = "收寄日期:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
    sheet1.row(0).default_format = filter

    sheet1[2,0] = "中免项目同城邮件投递情况--#{Date.today.strftime('%Y-%m-%d')}"
    0.upto(7) do |x|
      sheet1.row(2).set_format(x, title)
    end
    sheet1.merge_cells(2, 0, 2, 7)

    0.upto(7) do |x|
      sheet1.row(3).set_format(x, title)
    end
  	sheet1.row(3).concat %w{区县 下段总数 投递中 已妥投 未妥投 退件 未下段 总计(解车)}  
  	count_row = 4

  	results[0].each do |k, v|
  		sheet1[count_row,0] = k[1]
  		sheet1[count_row,1] = v[0]
  		sheet1[count_row,2] = v[1]
  		sheet1[count_row,3] = v[2]
  		sheet1[count_row,4] = v[3]
  		sheet1[count_row,5] = v[4]
  		sheet1[count_row,6] = v[5]
  		sheet1[count_row,7] = v[6]
  		
	  	0.upto(7) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	  end

	  # 合计
	  0.upto(7) do |i|
  		sheet1[count_row,i] = results[1][i]
  		sheet1.row(count_row).set_format(i, body)
	  end


	  # 明细（总计）表
	  sheet2[0,0] = "收寄日期:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
    sheet2.row(0).default_format = filter

    0.upto(4) do |x|
      sheet2.row(2).set_format(x, title)
    end
  	sheet2.row(2).concat %w{序号 邮件号 当前处理机构 区县 妥投情况}  
  	count_row = 3

  	expresses.each do |x|
  		sheet2[count_row,0] = count_row-2
  		sheet2[count_row,1] = x.express_no
  		sheet2[count_row,2] = x.last_unit.try(:name)
  		sheet2[count_row,3] = x.last_unit.blank? ? "" : (x.last_unit.parent_unit.blank? ? "" : x.last_unit.parent_unit.try(:name))
  		sheet2[count_row,4] = x.zm_deliver_report_detail_status.blank? ? "" : x.zm_deliver_report_detail_status

  		0.upto(4) do |i|
	      sheet2.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	  end

	  book.write xls_report  
    xls_report.string 
  end

  # 中免运营日报
  def zm_operation_report
  	@is_search = nil
  	@results = nil
  	
		unless request.get?
  		if !params[:posting_date_start].blank? && !params[:posting_date_end].blank? && ((params[:posting_date_end].to_date - params[:posting_date_start].to_date) < 7)
  			@is_search = "yes"
	  		@posting_date_start = params[:posting_date_start].to_date
				@posting_date_end = params[:posting_date_end].to_date+1.day
  		
	  		expresses = Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ?", "1100207488562", @posting_date_start, @posting_date_end)

				if expresses.blank?
		    	flash[:alert] = "无数据"
		    else	  	
		    	@results = Report.get_zm_operation_result(expresses)
		    end
		  else
		  	flash[:alert] = "起止日期不能超过7天 "
	  	end
		end
	end

	# 中免运营日报导出
	def zm_operation_report_export
		@posting_date_start = params[:posting_date_start].to_date
		@posting_date_end = params[:posting_date_end].to_date+1.day
	
		expresses = Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ?", "1100207488562", @posting_date_start, @posting_date_end)

  	if expresses.blank?
    	flash[:alert] = "无数据"
    else	  	
    	@results = Report.get_zm_operation_result(expresses)
    	send_data(zm_operation_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "中免运营日报_#{Time.now.strftime("%Y%m%d")}.xls") 
    end
	end

  def zm_operation_report_xls_content_for(params, results)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "中免运营日报" 
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    sheet1[0,0] = "收寄日期:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
    sheet1.row(0).default_format = filter

    sheet1[2,0] = "中免日上互联科技有限公司运营日报"
    sheet1.merge_cells(2, 0, 2, 4)
    sheet1[2,5] = "汇总"
    sheet1[2,7] = "华东区域江浙沪皖次日达时效"
    sheet1.merge_cells(2, 7, 2, 9)
    0.upto(11) do |x|
      sheet1.row(2).set_format(x, title)
    end

  	sheet1.row(3).concat %w{日期 接收总单呈 在途 未妥投 妥投 妥投率 接收总单量 妥投 次日达 占比 运输中 配送中}
  	0.upto(11) do |x|
      sheet1.row(3).set_format(x, title)
    end

  	# 合计
	  0.upto(11) do |i|
  		sheet1[4,i] = results[1][i]
  		sheet1.row(4).set_format(i, body)
	  end

  	count_row = 5

  	results[0].each do |k, v|
  		sheet1[count_row,0] = k
  		0.upto(10) do |i|
  			sheet1[count_row,i+1] = v[i]
  		end

  		0.upto(11) do |j|
	      sheet1.row(count_row).set_format(j, body)
	    end
	    count_row += 1
  	end

  	book.write xls_report  
    xls_report.string 
  end

  # 中免全国在途汇总表（省公司维度）
  def zm_province_report
  	@is_search = nil
  	@results = nil
  	
		unless request.get?
  		if !params[:posting_date_start].blank? && !params[:posting_date_end].blank? && ((params[:posting_date_end].to_date - params[:posting_date_start].to_date) < 7)
  			@is_search = "yes"
	  		@posting_date_start = params[:posting_date_start].to_date
				@posting_date_end = params[:posting_date_end].to_date+1.day
  		
	  		expresses = Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ? and status = ?", "1100207488562", @posting_date_start, @posting_date_end, "waiting")

				if expresses.blank?
		    	flash[:alert] = "无数据"
		    else	  	
		    	@results = Report.get_zm_province_result(expresses)
		    end
		  else
		  	flash[:alert] = "起止日期不能超过7天 "
	  	end
		end
	end

	# 中免全国在途汇总表（省公司维度）导出
	def zm_province_report_export
		@posting_date_start = params[:posting_date_start].to_date
		@posting_date_end = params[:posting_date_end].to_date+1.day
	
		expresses =Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ? and status = ?", "1100207488562", @posting_date_start, @posting_date_end, "waiting")

  	if expresses.blank?
    	flash[:alert] = "无数据"
    else	  	
    	@results = Report.get_zm_province_result(expresses)
    	send_data(zm_province_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "中免全国在途汇总表（省公司维度）_#{Time.now.strftime("%Y%m%d")}.xls") 
    end
	end

	def zm_province_report_xls_content_for(params, results)
		xls_report = StringIO.new  
	  book = Spreadsheet::Workbook.new  
	  sheet1 = book.create_worksheet :name => "中免全国在途汇总表（省公司维度）"

	  filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
	  title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
	  body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

	  sheet1[0,0] = "收寄日期:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
	  sheet1.row(0).default_format = filter

	  0.upto(3) do |x|
	    sheet1.row(2).set_format(x, title)
	  end
		sheet1.row(2).concat %w{收件省份 在途总量(件) 时限内在途量(件) 超时在途量(件)}  
		count_row = 3

		results[0].each do |k, v|
			sheet1[count_row,0] = k[1]
			sheet1[count_row,1] = v[0]
			sheet1[count_row,2] = v[1]
			sheet1[count_row,3] = v[2]

			0.upto(3) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	  end

	  # 合计
	  0.upto(3) do |i|
			sheet1[count_row,i] = results[1][i]
			sheet1.row(count_row).set_format(i, body)
	  end

	  book.write xls_report  
	  xls_report.string 
	end

	# 中免全国时限达成情况表
  def zm_time_limit_report
  	@is_search = nil
  	@results = nil
  	
		unless request.get?
  		if !params[:posting_date_start].blank? && !params[:posting_date_end].blank? && ((params[:posting_date_end].to_date - params[:posting_date_start].to_date) < 7)
  			@is_search = "yes"
	  		@posting_date_start = params[:posting_date_start].to_date
				@posting_date_end = params[:posting_date_end].to_date+1.day
  			# 除上海、港澳
	  		expresses = Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ?", "1100207488562", @posting_date_start, @posting_date_end).where("receiver_province_no not in (?)", ['310000', '810000', '820000'])

				if expresses.blank?
		    	flash[:alert] = "无数据"
		    else	  	
		    	@results = Report.get_zm_time_limit_result(expresses, params)
		    end
		  else
		  	flash[:alert] = "起止日期不能超过7天 "
	  	end
		end
	end

	# 中免全国时限达成情况表导出
	def zm_time_limit_report_export
		@posting_date_start = params[:posting_date_start].to_date
		@posting_date_end = params[:posting_date_end].to_date+1.day
		# 除上海、港澳
		expresses = Express.left_outer_joins(:business).where("businesses.code = ? and posting_date  >= ? and posting_date < ?", "1100207488562", @posting_date_start, @posting_date_end).where("receiver_province_no not in (?)", ['310000', '810000', '820000'])

  	if expresses.blank?
    	flash[:alert] = "无数据"
    else	  	
    	@results = Report.get_zm_time_limit_result(expresses, params)
    	send_data(zm_time_limit_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "中免全国时限达成情况表_#{Time.now.strftime("%Y%m%d")}.xls") 
    end
	end

	def zm_time_limit_report_xls_content_for(params, results)
		xls_report = StringIO.new  
	  book = Spreadsheet::Workbook.new  
	  sheet1 = book.create_worksheet :name => "中免全国时限达成情况表"

	  filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
	  title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
	  body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

	  sheet1[0,0] = "收寄日期:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
	  sheet1.row(0).default_format = filter

	  sheet1[2,0] = "上海仓始发中免项目邮件时限达成情况统计"
	  col = ((params["posting_date_end"].to_date-params["posting_date_start"].to_date).to_i+1)*3
    sheet1.merge_cells(2, 0, 2, col)
    
	  sheet1[3,0] = "收寄日期"
	  c = 1
	  results[2].each do |date|
	  	sheet1[3,c] = date
	  	sheet1.merge_cells(3, c, 3, c+2)
	  	c += 3
	  end
	  
	  sheet1[4,0] = "省份"
	  d = 1
	  results[2].each do |date|
	  	sheet1[4,d] = "收寄量"
	  	sheet1[4,d+1] = "时限内妥投"
	  	sheet1[4,d+2] = "时限达成率"
	  	d += 3
	  end
	  2.upto(4) do |y|
	  	0.upto(col) do |x|
	    	sheet1.row(y).set_format(x, title)
	    end
	  end

	  count_row = 5
	  results[3].each do |prov|
	  	sheet1[count_row,0] = prov[1]
	  	e = 1
	  	results[2].each do |date|
	  		sheet1[count_row,e] = results[0][[prov,date]][0]
	  		sheet1[count_row,e+1] = results[0][[prov,date]][1]
	  		sheet1[count_row,e+2] = results[0][[prov,date]][2]
	  		e += 3
	  	end

	  	0.upto(col) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	  end

	  # 合计
	  sheet1[count_row,0] = "合计"
	  f = 1
	  results[2].each do |date|
	  	sheet1[count_row,f] = results[1][date][0]
	  	sheet1[count_row,f+1] = results[1][date][1]
	  	sheet1[count_row,f+2] = results[1][date][2]
	  	f += 3
  	end
  	0.upto(col) do |i|
      sheet1.row(count_row).set_format(i, body)
    end

    book.write xls_report  
	  xls_report.string 
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
	    sheet1[3,2] = "次日上午未妥投:#{(!params["undelivered_nextday"].blank? && (params["undelivered_nextday"].eql?'1')) ? '是' : ''}"
	    
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

	  	all_results = Report.get_deliver_unit_result(expresses, params)
      @results = all_results[0]
      @parent_unit_results = all_results[1]
  	end

  	def deliver_unit_report_xls_content_for(params,results,parent_unit_results)
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
	    sheet1[3,2] = "次日上午未妥投:#{(!params["undelivered_nextday"].blank? && (params["undelivered_nextday"].eql?'1')) ? '是' : ''}"

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
	    last_pid = results.values[0]

	    results.each do |k, v|
	    	if (params[:is_monitor].eql?"false") && (params[:is_court].eql?"false") && (v[0] != last_pid) && !parent_unit_results[last_pid].blank?
	    		sheet1[count_row,0] =  parent_unit_results[last_pid][0]
		      sheet1[count_row,1] = ""
		      sheet1[count_row,2] = parent_unit_results[last_pid][1]
		      sheet1[count_row,3] = parent_unit_results[last_pid][2]
		      sheet1[count_row,4] = parent_unit_results[last_pid][3]
		      sheet1[count_row,5] = parent_unit_results[last_pid][4]
		      sheet1[count_row,6] = parent_unit_results[last_pid][5]
		      sheet1[count_row,7] = parent_unit_results[last_pid][6].to_s(:rounded, precision: 2)+"%"
		      j = 0.0
	        col = 8
	        while j <= params[:delivered_days_show].to_f-1
	          sheet1[count_row,col] = (parent_unit_results[last_pid][14][j]/parent_unit_results[last_pid][1]).to_s(:rounded, precision: 2)+"%"
	          col += 1
	          j += 0.5
	        end

	        sheet1[count_row,col] = parent_unit_results[last_pid][13]
		      sheet1[count_row,col+1] = parent_unit_results[last_pid][7]
		      sheet1[count_row,col+2] = parent_unit_results[last_pid][11]
		      sheet1[count_row,col+3] = parent_unit_results[last_pid][12]
		      sheet1[count_row,col+4] = parent_unit_results[last_pid][8].to_s(:rounded, precision: 2)+"%"
		      sheet1[count_row,col+5] = parent_unit_results[last_pid][9]
		      sheet1[count_row,col+6] = parent_unit_results[last_pid][10].to_s(:rounded, precision: 2)+"%"

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
	    sheet1[3,2] = "次日上午未妥投:#{(!params["undelivered_nextday"].blank? && (params["undelivered_nextday"].eql?'1')) ? '是' : ''}"
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
	    sheet1[3,2] = "次日上午未妥投:#{(!params["undelivered_nextday"].blank? && (params["undelivered_nextday"].eql?'1')) ? '是' : ''}"

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
	    sheet1[3,2] = "次日上午未妥投:#{(!params["undelivered_nextday"].blank? && (params["undelivered_nextday"].eql?'1')) ? '是' : ''}"
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

	  def init_international_result
  		authorize! "report", "InternationalExpressReport"

	  	@results = nil
 		  	
    	international_expresses = Report.get_filter_international_expresses(params).accessible_by(current_ability)
    	if international_expresses.blank?
      	flash[:alert] = "无数据"
      else	  	
      	@results = Report.get_international_result(international_expresses, params)
      end
    end

	  def international_express_report_xls_content_for(params,results)
	  	xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "统计表"  
	    
	    report_name = Spreadsheet::Format.new :weight => :bold, :size => 20, :align => :center, :name => "宋体"
	    filter = Spreadsheet::Format.new :size => 16, :align => :left, :name => "宋体"
	    body = Spreadsheet::Format.new :size => 14, :border => :thin, :align => :center, :name => "宋体"
	    hj = Spreadsheet::Format.new :weight => :bold, :size => 14, :border => :thin, :align => :center, :name => "宋体"
	    # red = Spreadsheet::Format.new :color => :red, :size => 11, :border => :thin, :align => :center
	    country = Country.find(params["country_id"].to_i)
	    business = params["business_id"].blank? ? nil : Business.find(params["business_id"].to_i) 
	    sheet1[0,0] = "VIP客户时效跟踪"
	    sheet1.merge_cells(0, 0, 0, 47)
	    sheet1.row(0).default_format = report_name

	    sheet1[1,0] = "寄达国: #{country.name}"
	    sheet1[1,3] = "客户: #{business.blank? ? '' : business.name}"
	    sheet1[1,8] = "收寄日期：#{params["posting_date_start"]}~#{params["posting_date_end"]}"
	    sheet1.merge_cells(0, 0, 0, 47)
	    sheet1.row(1).default_format = filter
    
	    sheet1[2,9] = "C=国家+时间"
	    sheet1.merge_cells(2, 9, 2, 11)
	    sheet1[2,15] = "D=国家+时间"
	    sheet1.merge_cells(2, 15, 2, 17)
	    sheet1[2,27] = "A1=国家+时间1"
	    sheet1.merge_cells(2, 27, 2, 29)
	    sheet1[2,30] = "A2=国家+时间2+收寄截止时间"
	    sheet1.merge_cells(2, 30, 2, 32)
	    sheet1[2,42] = "B=国家+时间"
	    sheet1.merge_cells(2, 42, 2, 44)
	    0.upto(47) do |i|
	      sheet1.row(2).set_format(i, body)
	    end
	    
	    0.upto(47) do |x|
	      sheet1.row(3).set_format(x, body)
	      sheet1.row(4).set_format(x, body)
	    end
	    pre_title3 = ["序号", "客户名称", "寄达国", "地区", "业务量", "重量（克）", "退回妥投量", "退回妥投占比", "退回妥投量（安检未过）"]
	    i = 0
	    while i<pre_title3.size
		    sheet1[3,i] = pre_title3[i]
		    sheet1.merge_cells(3, i, 4, i)
		    i += 1
		  end

		  after_title3 = ["总包到达寄达地(T+#{country.arrive.blank? ? '24' : country.arrive})", "总包到达寄达地(>T+#{country.arrive.blank? ? '24' : country.arrive})", "离开境外处理中心(T+#{country.leave.blank? ? '48' : country.leave})", "离开境外处理中心(>T+#{country.leave.blank? ? '48' : country.leave})", "收寄局已封车(T)", "收寄局未封车(其他)", "互换局封车1(T+#{country.interchange1.blank? ? '12' : country.interchange1})", "互换局封车2(T+#{country.interchange2.blank? ? '36' : country.interchange2}+18)", "互换局未及时封车", "互换局已封车", "互换局未封车", "航空启运信息(T+#{country.air.blank? ? '24' : country.air})", "航空启运信息(>T+#{country.air.blank? ? '24' : country.air})"]
		  title4 = ["业务量", "重量（克）", "占比"]
		  j = 9
		  k = 0
		  while k<after_title3.size
			  sheet1[3,j] = after_title3[k]
		    sheet1.merge_cells(3, j, 3, j+2)
		    sheet1[4,j] = title4[0]
		  	sheet1[4,j+1] = title4[1]
		  	sheet1[4,j+2] = title4[2]
		    j += 3
		    k += 1
		  end

	    count_row = 5

	    results.each do |key, value|
	    	sheet1[count_row,0] = value[0]    #序号
	      sheet1[count_row,1] = value[1]    #客户名称
	      sheet1[count_row,2] = value[3]    #寄达国
	      sheet1[count_row,3] = value[4]    #地区
	      sheet1[count_row,4] = value[5]    #业务量
	      sheet1[count_row,5] = value[6]    #重量（克）
	      sheet1[count_row,6] = value[7]    #退回妥投量
	      sheet1[count_row,7] = value[8].to_s(:rounded, precision: 2)+"%"    #退回妥投占比
	      sheet1[count_row,8] = ""          #退回妥投量（安检未过）
	      sheet1[count_row,9] = value[36]    #总包到达寄达地(T+24)业务量
	      sheet1[count_row,10] = value[37]    #总包到达寄达地(T+24)重量（克）
	      sheet1[count_row,11] = value[38].to_s(:rounded, precision: 2)+"%"    #总包到达寄达地(T+24)占比
	      sheet1[count_row,12] = value[39]    #总包到达寄达地(>T+24)业务量
	      sheet1[count_row,13] = value[40]    #总包到达寄达地(>T+24)重量（克）
	      sheet1[count_row,14] = value[41].to_s(:rounded, precision: 2)+"%"    #总包到达寄达地(>T+24)占比
	      sheet1[count_row,15] = value[42]    #离开境外处理中心(T+48)业务量
	      sheet1[count_row,16] = value[43]    #离开境外处理中心(T+48)重量（克）
	      sheet1[count_row,17] = value[44].to_s(:rounded, precision: 2)+"%"    #离开境外处理中心(T+48)占比
	      sheet1[count_row,18] = value[45]    #离开境外处理中心(>T+48)业务量
	      sheet1[count_row,19] = value[46]    #离开境外处理中心(>T+48)重量（克）
	      sheet1[count_row,20] = value[47].to_s(:rounded, precision: 2)+"%"    #离开境外处理中心(>T+48)占比
	      sheet1[count_row,21] = value[9]    #收寄局已封车(T)业务量
	      sheet1[count_row,22] = value[10]    #收寄局已封车(T)重量（克）
	      sheet1[count_row,23] = value[11].to_s(:rounded, precision: 2)+"%"    #收寄局已封车(T)占比
	      sheet1[count_row,24] = value[12]    #收寄局未封车(其他)业务量
	      sheet1[count_row,25] = value[13]    #收寄局未封车(其他)重量（克）
	      sheet1[count_row,26] = value[14].to_s(:rounded, precision: 2)+"%"    #收寄局未封车(其他)占比
	      sheet1[count_row,27] = value[15]    #互换局封车1(T+12)业务量
	      sheet1[count_row,28] = value[16]    #互换局封车1(T+12)重量（克）
	      sheet1[count_row,29] = value[17].to_s(:rounded, precision: 2)+"%"    #互换局封车1(T+12)占比
	      sheet1[count_row,30] = value[18]    #互换局封车2(T+36+18)业务量
	      sheet1[count_row,31] = value[19]    #互换局封车2(T+36+18)重量（克）
	      sheet1[count_row,32] = value[20].to_s(:rounded, precision: 2)+"%"    #互换局封车2(T+36+18)占比
	      sheet1[count_row,33] = value[21]    #互换局未及时封车业务量
	      sheet1[count_row,34] = value[22]    #互换局未及时封车重量（克）
	      sheet1[count_row,35] = value[23].to_s(:rounded, precision: 2)+"%"    #互换局未及时封车占比
	      sheet1[count_row,36] = value[24]    #互换局已封车业务量
	      sheet1[count_row,37] = value[25]    #互换局已封车重量（克）
	      sheet1[count_row,38] = value[26].to_s(:rounded, precision: 2)+"%"    #互换局已封车占比
	      sheet1[count_row,39] = value[27]    #互换局未封车业务量
	      sheet1[count_row,40] = value[28]    #互换局未封车重量（克）
	      sheet1[count_row,41] = value[29].to_s(:rounded, precision: 2)+"%"    #互换局未封车占比
	      sheet1[count_row,42] = value[30]    #航空启运信息(T+24)业务量
	      sheet1[count_row,43] = value[31]    #航空启运信息(T+24)重量（克）
	      sheet1[count_row,44] = value[32].to_s(:rounded, precision: 2)+"%"    #航空启运信息(T+24)占比
	      sheet1[count_row,45] = value[33]    #航空启运信息(>T+24)业务量
	      sheet1[count_row,46] = value[34]    #航空启运信息(>T+24)重量（克）
	      sheet1[count_row,47] = value[35].to_s(:rounded, precision: 2)+"%"    #航空启运信息(>T+24)占比

	      
	      0.upto(47) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
		    
	      count_row += 1
	    end

	    0.upto(47) do |i|
	      sheet1.row(count_row-1).set_format(i, hj)
	    end

	    book.write xls_report  
	    xls_report.string

	  end
end