class AirMailsController < ApplicationController
	load_and_authorize_resource :air_mail

	def index
    @air_mails = AirMail.get_filter_air_mails(params).accessible_by(current_ability)
    
    @air_mails_grid = initialize_grid(@air_mails, :per_page => params[:page_size],
      name: 'air_mails',
      :order => 'air_mails.mail_no',
      :order_direction => 'asc',
      :enable_export_to_csv => true,
      :csv_file_name => 'air_mails',
      :csv_encoding => 'gbk')
    export_grid_if_requested
  end



	#邮航进出口邮件导出
	def export
		unless request.get?
			flight_date_start = params[:flight_date_start].blank? ? Date.today : params[:flight_date_start].to_date
			flight_date_end = params[:flight_date_end].blank? ? Date.today+10.hours : params[:flight_date_end].to_date+10.hours
			direction = params[:direction]

			results = AirMail.where("air_mails.flight_date >= ? and air_mails.flight_date < ? and air_mails.direction = ?",flight_date_start, flight_date_end, direction)

			if results.blank?
	      flash[:alert] = "无数据"
	    else
	    	send_data(air_mail_xls_content_for(params, results),:type => "text/excel;charset=utf-8; header=present",:filename => "邮航进出口邮件导出_#{Time.now.strftime("%Y%m%d")}.xls")  
	    end
	  end
  end

  def air_mail_xls_content_for(params,results)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "邮航进出口邮件"  
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    sheet1[0,0] = "起飞时间:#{params["flight_date_start"]} 00:00:00 ~ #{params["flight_date_end"]} 10:00:00"
    sheet1[1,0] = "进口/出口: #{AirMail::DIRECTION["#{params[:direction]}".to_sym]}"
    sheet1.row(0).default_format = filter
    sheet1.row(1).default_format = filter

    0.upto(11) do |x|
      sheet1.row(3).set_format(x, title)
    end
  	sheet1.row(3).concat %w{运单号 寄件省份名称 寄件城市名称 寄件区县名称 重量 邮资 收寄时间 起飞时间 航班号 进口/出口 收寄机构号 收寄机构名称}  

  	count_row = 4
    results.each do |obj|
      sheet1[count_row,0]=obj.try :mail_no
      sheet1[count_row,1]=obj.try :sender_province_name
      sheet1[count_row,2]=obj.try :sender_city_name
      sheet1[count_row,3]=obj.try :sender_county_name
      sheet1[count_row,4]=obj.try :fee_weight
      sheet1[count_row,5]=obj.try :postage_total
      sheet1[count_row,6]=obj.try(:posting_date).strftime("%Y-%m-%d")
      sheet1[count_row,7]=obj.try(:flight_date).strftime("%Y-%m-%d")
      sheet1[count_row,8]=obj.try :flight_number
      sheet1[count_row,9]=AirMail::DIRECTION[obj.try(:direction).to_sym]
      sheet1[count_row,10]=obj.try :post_unit_no
      sheet1[count_row,11]=obj.try :post_unit_name
      
      0.upto(11) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
      count_row += 1
    end 
    book.write xls_report  
    xls_report.string  
  end

  #邮航出口邮件报表
  def ex_report
  	@is_search = nil
  	@ex_results = []
  	
  	@posting_date_start = params[:posting_date_start].blank? ? Date.yesterday : params[:posting_date_start].to_date
		@posting_date_end = params[:posting_date_end].blank? ? Date.today : params[:posting_date_end].to_date+1.day

  	unless request.get?
			@is_search = "yes"		

			air_mails = AirMail.left_outer_joins(:post_unit).left_outer_joins(:post_unit=>:parent_unit).where("air_mails.posting_date >= ? and air_mails.posting_date < ? and air_mails.direction = ?", @posting_date_start, @posting_date_end, 'export')

			if !air_mails.blank?
				@results = get_ex_report_result(air_mails, params)
	    else
	    	flash[:alert] = "无数据"
	    end
		end
  end

  def get_ex_report_result(air_mails, params)
  	unit_results = {}
  	parent_unit_results = {}
    hj = [0, 0, 0]
    amount_xj = 0
    weight_xj = 0
    postage_xj = 0
    
		# 计数
    amounts = air_mails.group(:post_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").order("units.parent_id, air_mails.post_unit_id").count
    # 重量
    weights = air_mails.group(:post_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").order("units.parent_id, air_mails.post_unit_id").sum("air_mails.fee_weight")
    # 邮资
    postages = air_mails.group(:post_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").order("units.parent_id, air_mails.post_unit_id").sum("air_mails.postage_total")

    last_parent_id = amounts.keys[0][2]

    amounts.each do |k, v|
      post_unit_id = k[0]
      # 0上级单位id, 1上级单位名称, 2单位名称, 3计数, 4重量, 5邮资
      unit_results[post_unit_id] = [k[2], k[3], k[1], v, weights[k], postages[k]]
      
      if k[2] == last_parent_id
        amount_xj += v
		    weight_xj += weights[k]
		    postage_xj += postages[k]
		  else
		  	parent_unit_results[last_parent_id] = ["小计", amount_xj, weight_xj, postage_xj]
		  	hj = [hj[0]+amount_xj, hj[1]+weight_xj, hj[2]+postage_xj]
		  	amount_xj = v
		    weight_xj = weights[k]
		    postage_xj = postages[k]
		  end

      last_parent_id = k[2]
    end
    parent_unit_results[last_parent_id] = ["小计", amount_xj, weight_xj, postage_xj]
  	hj = [hj[0]+amount_xj, hj[1]+weight_xj, hj[2]+postage_xj]

    unit_results = unit_results.sort{|x,y|  (x[0].nil? || x[1][0].nil?) ? 1 : ((y[0].nil? || y[1][0].nil?)? -1 : x[1][0]<=>y[1][0]) }.to_h 
		
		return [unit_results, parent_unit_results, hj]
	end

	# 邮航出口邮件报表导出
	def ex_report_export
  	posting_date_start = params[:posting_date_start].to_date
		posting_date_end = params[:posting_date_end].to_date

		air_mails = AirMail.left_outer_joins(:post_unit).left_outer_joins(:post_unit=>:parent_unit).where("air_mails.posting_date >= ? and air_mails.posting_date < ? and air_mails.direction = ?", posting_date_start, posting_date_end, 'export')

  	if air_mails.blank?
      flash[:alert] = "无数据"
      redirect_to request.referer
    else
    	@results = get_ex_report_result(air_mails, params)
    	send_data(ex_report_xls_content_for(params, @results),:type => "text/excel;charset=utf-8; header=present",:filename => "邮航出口邮件报表_#{Time.now.strftime("%Y%m%d")}.xls")  
    end
  end

  def ex_report_xls_content_for(params,results)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "统计表"  
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    sheet1[0,0] = "收寄时间:#{params["posting_date_start"]} ~ #{params["posting_date_end"]}"
    sheet1.row(0).default_format = filter

    0.upto(4) do |x|
      sheet1.row(2).set_format(x, title)
    end
  	sheet1.row(2).concat %w{所属上级机构 收寄机构名称 计数 重量(g) 邮资}  

  	# 收寄机构: @results[0][收寄机构id] = [0上级单位id, 1上级单位名称, 2单位名称, 3计数, 4重量, 5邮资]
    # 上级单位小计: @results[1][上级单位id] = [0"小计", 1计数, 2重量, 3邮资]
    # 合计: @results[2] = [0计数, 1重量, 2邮资]
  	count_row = 3
  	last_pid = results[0].values[0]
    results[0].each do |k, v|
    	# 上级单位不同，加小计
    	if (v[0] != last_pid) && !results[1][last_pid].blank?
	      sheet1[count_row,0] = results[1][last_pid][0]
	      sheet1[count_row,1] = ""
	      sheet1[count_row,2] = results[1][last_pid][1]
	      sheet1[count_row,3] = results[1][last_pid][2]
	      sheet1[count_row,4] = results[1][last_pid][3]

	      0.upto(4) do |i|
		      sheet1.row(count_row).set_format(i, body)
		    end
	      count_row += 1
	    end
	    # 收寄机构
	    sheet1[count_row,0] = k.blank? ? "" : ((v[0] == last_pid) ? "" : v[1])
	    sheet1[count_row,1] = k.blank? ? "其他" : v[2]
	    sheet1[count_row,2] = v[3]
	    sheet1[count_row,3] = v[4]
	    sheet1[count_row,4] = v[5]

	    0.upto(4) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	    last_pid = v[0]
	  end

	  sheet1[count_row,0] = results[1][last_pid][0]
    sheet1[count_row,1] = ""
    sheet1[count_row,2] = results[1][last_pid][1]
    sheet1[count_row,3] = results[1][last_pid][2]
    sheet1[count_row,4] = results[1][last_pid][3]

    0.upto(4) do |i|
      sheet1.row(count_row).set_format(i, body)
    end
    count_row += 1

    sheet1[count_row,0] = "合计"
    sheet1[count_row,1] = ""
    sheet1[count_row,2] = results[2][0]
    sheet1[count_row,3] = results[2][1]
    sheet1[count_row,4] = results[2][2]

    0.upto(4) do |i|
      sheet1.row(count_row).set_format(i, body)
    end

    book.write xls_report  
    xls_report.string 
  end

  #邮航进口邮件报表
  def imp_report
  	@is_search = nil
  	@imp_results = []

  	unless request.get?
  		if !params[:flight_date_start].blank? && !params[:flight_date_end].blank? && ((params[:flight_date_end].to_date-params[:flight_date_start].to_date)<=7)
		  	@flight_date_start = params[:flight_date_start].to_date-13.5.hours
				@flight_date_end = params[:flight_date_end].to_date+10.5.hours

				@fno1 = params[:fno1].blank? ? false : true
				@fno2 = params[:fno2].blank? ? false : true
				flight_number = []

	  		flight_number << I18n.t('flight_number.fno1') if @fno1
				flight_number << I18n.t('flight_number.fno2') if @fno2
				if flight_number.blank?
					flash[:alert] = "请勾选航班号"
					return
				end
				@is_search = "yes"	
				
				air_mails = AirMail.where("air_mails.direction = ? and air_mails.flight_date >= ? and air_mails.flight_date < ? and air_mails.flight_number in (?)", "import", @flight_date_start, @flight_date_end, flight_number)

				if !air_mails.blank?
					@results = get_imp_report_result(air_mails, flight_number)
		    else
		    	flash[:alert] = "无数据"
		    end
		  else
		  	flash[:alert] = "航班降落起止日期不能超过7天"
		  end
		end
  end

  def get_imp_report_result(air_mails, flight_number)
  	t1_results = {}
  	t1_hj_results = {}
  	t2_results = {}
  	t2_hj_results = {}
  	transfer_center_unit_no = {}
  	transfer_center_unit_no["20000414"] = "王港"
  	transfer_center_unit_no["20000061"] = "桃浦"
  	
  	t1 = air_mails.group(:flight_number, :is_arrive_jm, :is_leave_jm).count
  	t2 = air_mails.group(:flight_number, :transfer_center_unit_no, :is_arrive_center, :is_leave_center, :is_leave_center_in_time).count

  	# t1_results[a航班号] = [b航班件数, c嘉民接收, d差异(航班件数-嘉民接收), e嘉民发出, h总差异(嘉民接收-嘉民发出)]
  	flight_number.each do |x|
  		t1_b = t1.select { |key, _| (key[0].eql?x)}.values.sum
  		t1_c = t1.select { |key, _| (key[0].eql?x) && key[1]}.values.sum
  		t1_e = t1.select { |key, _| (key[0].eql?x) && key[2]}.values.sum
  		t1_results[x] = [t1_b,t1_c,t1_b-t1_c,t1_e,t1_c-t1_e]
  	end 
  	t1_b_hj = t1.values.sum
  	t1_c_hj = t1.select { |key, _| key[1]}.values.sum
  	t1_e_hj = t1.select { |key, _| key[2]}.values.sum
  	t1_hj_results = ["合计", t1_b_hj, t1_c_hj, t1_b_hj-t1_c_hj, t1_e_hj, t1_c_hj-t1_e_hj]

  	# t2_results[a航班号, b处理中心编号] = [c处理中心到达, d处理中心发往下一站(实时), e实时差异(处理中心到达-处理中心发往下一站), f处理中心发往下一站(15点前), g截止15点前差异(处理中心到达-处理中心发往下一站(15点前)), 处理中心名称]
  	flight_number.each do |x|
  		transfer_center_unit_no.each do |bno, bname|
  			t2_c = t2.select { |key, _| (key[0].eql?x) && (key[1].eql?bno) && key[2]}.values.sum
  			t2_d = t2.select { |key, _| (key[0].eql?x) && (key[1].eql?bno) && key[3]}.values.sum
  			t2_f = t2.select { |key, _| (key[0].eql?x) && (key[1].eql?bno) && key[4]}.values.sum
  			t2_results[[x, bno]] = [t2_c, t2_d, t2_c-t2_d, t2_f, t2_c-t2_f, bname]
  		end
  		t2_c_hj = t2.select { |key, _| (key[0].eql?x) && key[2]}.values.sum
  		t2_d_hj = t2.select { |key, _| (key[0].eql?x) && key[3]}.values.sum
  		t2_f_hj = t2.select { |key, _| (key[0].eql?x) && key[4]}.values.sum
  		t2_hj_results[x] = ["合计",t2_c_hj,t2_d_hj,t2_c_hj-t2_d_hj,t2_f_hj,t2_c_hj-t2_f_hj]
  	end

  	return [t1_results, t1_hj_results, t2_results, t2_hj_results]
  end

  # 邮航进口邮件报表导出
	def imp_report_export
		if !params[:flight_date_start].blank? && !params[:flight_date_end].blank? && ((params[:flight_date_end].to_date-params[:flight_date_start].to_date)<=7)
	  	@flight_date_start = params[:flight_date_start].to_date-13.5.hours
			@flight_date_end = params[:flight_date_end].to_date+10.5.hours

			@fno1 = params[:fno1].blank? ? false : true
			@fno2 = params[:fno2].blank? ? false : true
			flight_number = []

  		flight_number << I18n.t('flight_number.fno1') if @fno1
			flight_number << I18n.t('flight_number.fno2') if @fno2
			if flight_number.blank?
				flash[:alert] = "请勾选航班号"
				return
			end

			air_mails = AirMail.where("air_mails.direction = ? and air_mails.flight_date >= ? and air_mails.flight_date < ? and air_mails.flight_number in (?)", "import", @flight_date_start, @flight_date_end, flight_number)

  		if air_mails.blank?
	      flash[:alert] = "无数据"
	      redirect_to request.referer
	    else
	    	@results = get_imp_report_result(air_mails, flight_number)
	    	send_data(imp_report_xls_content_for(params, @results, flight_number),:type => "text/excel;charset=utf-8; header=present",:filename => "邮航进口邮件报表_#{Time.now.strftime("%Y%m%d")}.xls")  
	    end
	  else
	  	flash[:alert] = "航班降落起止日期不能超过7天"
	  end
  end

  def imp_report_xls_content_for(params, results, flight_number)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "统计表"  
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    sheet1[0,0] = "航班降落日期:#{params["flight_date_start"]} ~ #{params["flight_date_end"]}"
    sheet1[1,0] = "航班号:#{flight_number.join(',')}"
    sheet1[3,0] = "到沪（嘉民）"
    0.upto(3) do |x|
      sheet1.row(x).default_format = filter
    end
    
    # table1
    0.upto(5) do |x|
      sheet1.row(5).set_format(x, title)
    end
  	sheet1.row(5).concat %w{A航班 B航班件数 C嘉民接收 D差异（B-C） E嘉民发出 H总差异(C-E)}  
  	count_row = 6
  	# results[0]=t1_results[a航班号] = [b航班件数, c嘉民接收, d差异(航班件数-嘉民接收), e嘉民发出, h总差异(嘉民接收-嘉民发出)]
  	results[0].each do |k, v|
  		sheet1[count_row,0] = k
  		sheet1[count_row,1] = v[0]
  		sheet1[count_row,2] = v[1]
  		sheet1[count_row,3] = v[2]
  		sheet1[count_row,4] = v[3]
  		sheet1[count_row,5] = v[4]

	  	0.upto(5) do |i|
	      sheet1.row(count_row).set_format(i, body)
	    end
	    count_row += 1
	  end
	  # 合计
	  0.upto(5) do |i|
  		sheet1[count_row,i] = results[1][i]
  		sheet1.row(count_row).set_format(i, body)
	  end

	  # table2
	  count_row += 2
	  0.upto(6) do |x|
      sheet1.row(count_row).set_format(x, title)
    end
  	sheet1.row(count_row).concat %w{A航班 B处理中心 C处理中心到达 D处理中心发往下一站(实时) E实时差异(C-D) F处理中心发往下一站(15点前) 截止15点前差异(C-F)}  
  	count_row += 1

  	# results[2] = t2_results[a航班号, b处理中心] = [c处理中心到达, d处理中心发往下一站(实时), e实时差异(处理中心到达-处理中心发往下一站), f处理中心发往下一站(15点前), g截止15点前差异(处理中心到达-处理中心发往下一站(15点前))]
  	last_flight_no = results[2].keys[0][0]
  	results[2].each do |k, v|
  		# 航班号不同，加小计
  		if (k[0] != last_flight_no) && !results[3][last_flight_no].blank?
  			sheet1[count_row,0] = ""
  			sheet1.row(count_row).set_format(0, body)
  			1.upto(6) do |i|
		  		sheet1[count_row,i] = results[3][last_flight_no][i-1]
		  		sheet1.row(count_row).set_format(i, body)
			  end
			  count_row += 1
			end

			sheet1[count_row,0] = (k.eql?results[2].keys[0]) ? k[0] : ((k[0].eql?last_flight_no) ? "" : k[0])
  		sheet1[count_row,1] = v[5]
  		sheet1[count_row,2] = v[0]
  		sheet1[count_row,3] = v[1]
  		sheet1[count_row,4] = v[2]
  		sheet1[count_row,5] = v[3]
  		sheet1[count_row,6] = v[4]

  		0.upto(6) do |i|
	  		sheet1.row(count_row).set_format(i, body)
		  end
		  
  		last_flight_no = k[0]
  		count_row += 1
  	end

  	sheet1[count_row,0] = ""
		sheet1.row(count_row).set_format(0, body)
		1.upto(6) do |i|
  		sheet1[count_row,i] = results[3][last_flight_no][i-1]
  		sheet1.row(count_row).set_format(i, body)
	  end

  	book.write xls_report  
    xls_report.string 
  end

  #邮航进口投递报表
  def imp_deliver_report
  	@is_search = nil
  	@imp_deliver_results = []

  	unless request.get?
  		if !params[:flight_date_start].blank? && !params[:flight_date_end].blank? && ((params[:flight_date_end].to_date-params[:flight_date_start].to_date)<=7)
		  	@flight_date_start = params[:flight_date_start].to_date-13.5.hours
				@flight_date_end = params[:flight_date_end].to_date+10.5.hours

				@fno1 = params[:fno1].blank? ? false : true
				@fno2 = params[:fno2].blank? ? false : true
				flight_number = []

	  		flight_number << I18n.t('flight_number.fno1') if @fno1
				flight_number << I18n.t('flight_number.fno2') if @fno2
				if flight_number.blank?
					flash[:alert] = "请勾选航班号"
					return
				end
				@is_search = "yes"	
				
				air_mails = AirMail.left_outer_joins(:last_unit).left_outer_joins(:last_unit=>:parent_unit).where("air_mails.direction = ? and air_mails.flight_date >= ? and air_mails.flight_date < ? and air_mails.flight_number in (?)", "import", @flight_date_start, @flight_date_end, flight_number)

				if !air_mails.blank?
					@results = get_imp_deliver_report_result(air_mails)
					@is_leave_center_amount = air_mails.where(is_leave_center: true).count
					@arrive_diff_amount = @is_leave_center_amount - @results[2][1]
		    else
		    	flash[:alert] = "无数据"
		    end
		  else
		  	flash[:alert] = "航班降落起止日期不能超过7天"
		  end
		end
  end

  def get_imp_deliver_report_result(air_mails)
  	u_results = {}
  	xj_results = {}
  	hj_results = []
  	other_results = []
  	p_units = {}
  	
  	t = air_mails.group(:last_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").group(:is_arrive_sub).group(:is_in_delivery).group(:is_delivered_in_time).order("units.parent_id, air_mails.last_unit_id").count

  	t.select { |key, _| p_units[key[2]] = key[3] if !key[2].blank? && (p_units[key[2]].blank?)}

  	p_units.each do |k,v|
  		u_units = {}
  		t.select { |key, _| u_units[key[0]] = key[1] if !key[0].blank? && (key[2]==k) && (u_units[key[0]].blank?)}

	  	u_units.each do |kk,vv|
	  		t_c = t.select { |key, _| (key[0].eql?kk) && key[4]}.values.sum
	  		t_d= t.select { |key, _| (key[0].eql?kk) && key[5]}.values.sum
	  		t_f= t.select { |key, _| (key[0].eql?kk) && key[6]}.values.sum
	  		# u_results[投递网点id] = [投递区局id, 投递区局名称, 投递网点名称, C到达, D下段, E差异(C-D), F当日妥投, G当日未妥投(C-F), H妥投率(F/D)]
	  		u_results[kk] = [k, v, vv, t_c, t_d, t_c-t_d, t_f, t_c-t_f, ((t_d==0) ? 0.0 : (t_f/t_d.to_f*100).round(2))]
	  	end

	  	t_c_xj = t.select { |key, _| (key[2].eql?k) && key[4]}.values.sum
  		t_d_xj= t.select { |key, _| (key[2].eql?k) && key[5]}.values.sum
  		t_f_xj= t.select { |key, _| (key[2].eql?k) && key[6]}.values.sum
	  	xj_results[k] = ["小计", t_c_xj, t_d_xj, t_c_xj-t_d_xj, t_f_xj, t_c_xj-t_f_xj, ((t_d_xj==0) ? 0.0 : (t_f_xj/t_d_xj.to_f*100).round(2))]
	  end

	  t_c_other = t.select { |key, _| (key[2].blank?) && key[4]}.values.sum
	  t_d_other = t.select { |key, _| (key[2].blank?) && key[5]}.values.sum
	  t_f_other = t.select { |key, _| (key[2].blank?) && key[6]}.values.sum
	  other_results = ["其他", t_c_other, t_d_other, t_c_other-t_d_other, t_f_other, t_c_other-t_f_other, ((t_d_other==0) ? 0.0 : (t_f_other/t_d_other.to_f*100).round(2))]

	  t_c_hj = t.select { |key, _| key[4]}.values.sum
		t_d_hj= t.select { |key, _| key[5]}.values.sum
		t_f_hj= t.select { |key, _| key[6]}.values.sum
		hj_results = ["总计", t_c_hj, t_d_hj, t_c_hj-t_d_hj, t_f_hj, t_c_hj-t_f_hj, ((t_d_hj==0) ? 0.0 : (t_f_hj/t_d_hj.to_f*100).round(2))]

		return [u_results, xj_results, hj_results, other_results]
	end

  # 邮航进口投递报表导出
  def imp_deliver_report_export
    if !params[:flight_date_start].blank? && !params[:flight_date_end].blank? && ((params[:flight_date_end].to_date-params[:flight_date_start].to_date)<=7)
      @flight_date_start = params[:flight_date_start].to_date-13.5.hours
      @flight_date_end = params[:flight_date_end].to_date+10.5.hours

      @fno1 = params[:fno1].blank? ? false : true
      @fno2 = params[:fno2].blank? ? false : true
      flight_number = []

      flight_number << I18n.t('flight_number.fno1') if @fno1
      flight_number << I18n.t('flight_number.fno2') if @fno2
      if flight_number.blank?
        flash[:alert] = "请勾选航班号"
        return
      end

      air_mails = AirMail.left_outer_joins(:last_unit).left_outer_joins(:last_unit=>:parent_unit).where("air_mails.direction = ? and air_mails.flight_date >= ? and air_mails.flight_date < ? and air_mails.flight_number in (?)", "import", @flight_date_start, @flight_date_end, flight_number)

      if air_mails.blank?
        flash[:alert] = "无数据"
        redirect_to request.referer
      else
        results = get_imp_deliver_report_result(air_mails)
        is_leave_center_amount = air_mails.where(is_leave_center: true).count
        arrive_diff_amount = is_leave_center_amount - results[2][1]
        send_data(imp_deliver_report_xls_content_for(params, results, flight_number, is_leave_center_amount, arrive_diff_amount),:type => "text/excel;charset=utf-8; header=present",:filename => "邮航进口投递报表_#{Time.now.strftime("%Y%m%d")}.xls")  
      end
    else
      flash[:alert] = "航班降落起止日期不能超过7天"
    end
  end

  def imp_deliver_report_xls_content_for(params, results, flight_number, is_leave_center_amount, arrive_diff_amount)
    xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "统计表"  
    
    filter = Spreadsheet::Format.new :size => 12, :align => :left, :name => "宋体"
    title = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体", :weight => :bold
    body = Spreadsheet::Format.new :size => 12, :border => :thin, :align => :center, :name => "宋体"

    sheet1[0,0] = "航班降落日期:#{params["flight_date_start"]} ~ #{params["flight_date_end"]}"
    sheet1[1,0] = "航班号:#{flight_number.join(',')}"
    sheet1[1,6] = "处理中心发出数：#{is_leave_center_amount}"
    sheet1[2,6] = "到达差异数：#{arrive_diff_amount}"

    0.upto(2) do |x|
      sheet1.row(x).default_format = filter
    end
    
    0.upto(7) do |x|
      sheet1.row(4).set_format(x, title)
    end
    sheet1.row(4).concat %w{A投递区局  B投递网点 C到达 D下段 E差异(C-D) F当日妥投 G当日未妥投(C-F) H妥投率(F/D)}  
    count_row = 5

    # 投递网点:@results[0][投递网点id] = [投递区局id, 投递区局名称, 投递网点名称, C到达, D下段, E差异(C-D), F当日妥投, G当日未妥投(C-F), H妥投率(F/D)]
    # 投递区局小计:@results[1][投递区局id] = ["小计", C到达, D下段, E差异(C-D), F当日妥投, G当日未妥投(C-F), H妥投率(F/D)] 
    # 总计:@results[2] = ["总计", C到达, D下段, E差异(C-D), F当日妥投, G当日未妥投(C-F), H妥投率(F/D)]
    # 其他: @results[3] = ["其他", C到达, D下段, E差异(C-D), F当日妥投, G当日未妥投(C-F), H妥投率(F/D)] 
    last_pid = results[0].values[0]
    results[0].each do |k, v|
      # 上级单位不同，加小计
      if (v[0] != last_pid) && !results[1][last_pid].blank?
        sheet1[count_row,0] = ""
        1.upto(6) do |i|
          sheet1[count_row,i] = results[1][last_pid][i-1]
        end
        sheet1[count_row,7] = results[1][last_pid][6].to_s(:rounded, precision: 2)+"%"
        
        0.upto(7) do |i|
          sheet1.row(count_row).set_format(i, body)
        end

        count_row += 1
      end

      # 投递网点
      sheet1[count_row,0] = (v[0] == last_pid) ? "" : v[1]
      sheet1[count_row,1] = k.blank? ? "" : v[2]
      2.upto(6) do |i|
        sheet1[count_row,i] = results[0][k][i+1]
      end
      sheet1[count_row,7] = results[0][k][8].to_s(:rounded, precision: 2)+"%"
        
      0.upto(7) do |i|
        sheet1.row(count_row).set_format(i, body)
      end

      last_pid = v[0]
      count_row += 1
    end

    sheet1[count_row,0] = ""
    1.upto(6) do |i|
      sheet1[count_row,i] = results[1][last_pid][i-1]
    end
    sheet1[count_row,7] = results[1][last_pid][6].to_s(:rounded, precision: 2)+"%"
    
    0.upto(7) do |i|
      sheet1.row(count_row).set_format(i, body)
    end

    count_row += 1

    # 其他
    sheet1[count_row,0] = results[3][0]
    sheet1[count_row,1] = ""
    2.upto(6) do |i|
      sheet1[count_row,i] = results[3][i-1]
    end
    sheet1[count_row,7] = results[3][6].to_s(:rounded, precision: 2)+"%"

    0.upto(7) do |i|
      sheet1.row(count_row).set_format(i, body)
    end

    count_row += 1

    # 总计
    sheet1[count_row,0] = ""
    1.upto(6) do |i|
      sheet1[count_row,i] = results[2][i-1]
    end
    sheet1[count_row,7] = results[2][6].to_s(:rounded, precision: 2)+"%"
    
    0.upto(7) do |i|
      sheet1.row(count_row).set_format(i, body)
    end

    book.write xls_report  
    xls_report.string 
  end

  def get_mail_trace
    @traces = []
    mailtrace = MailTrace.find_by(mail_no: @air_mail.mail_no)
    if !mailtrace.blank?
      @traces = mailtrace.traces.split(/\n/)
    end
  end

end