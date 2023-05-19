class InternationalExpressesController < ApplicationController
  load_and_authorize_resource :international_express
  
  def index
    @international_expresses = Report.get_filter_international_expresses(params).accessible_by(current_ability)

    @international_expresss_grid = initialize_grid(@international_expresses, :per_page => params[:page_size],
      name: 'international_expresses',
      :enable_export_to_csv => true,
      :csv_file_name => 'international_expresses',
      :csv_encoding => 'gbk')
    export_grid_if_requested
  end

  def import
  	unless request.get?
  		if params[:file].blank? || params[:file]['file'].blank?
  			message = "请导入文件"
  			flash[:alert] = message
  		else
  			if file = upload_international_express_info(params[:file]['file'])       
	        ActiveRecord::Base.transaction do
	          begin
	          	selected_country_id = params[:country].to_i
	          	express_nos = []
	          	sheet_error = []
	            rowarr = [] 
	            instance=nil
	            current_line = 0

	            import_file = ImportFile.create! file_name: file.split("/").last, file_path: file, user_id: current_user.id, unit_id: current_user.unit_id, country_id: selected_country_id, batch_no: get_batch_no

	            if file.include?('.xlsx')
	              instance= Roo::Excelx.new(file)
	            elsif file.include?('.xls')
	              instance= Roo::Excel.new(file)
	            elsif file.include?('.csv')
	              instance= Roo::CSV.new(file)
	            end
	            instance.default_sheet = instance.sheets.first
	            row_count = instance.count
	            title_row = instance.row(1)
	            express_no_index = title_row.index("邮件号").blank? ? 1 : title_row.index("邮件号")
	            country_index = title_row.index("寄达国（地区）").blank? ? 3 : title_row.index("寄达国（地区）")
	            business_code_index = title_row.index("大宗客户代码").blank? ? 6 : title_row.index("大宗客户代码")
	            posting_date_index = title_row.index("收寄时间").blank? ? 11 : title_row.index("收寄时间")
	            receiver_postcode_index = title_row.index("收件人邮编").blank? ? 15 : title_row.index("收件人邮编")
	            weight_index = title_row.index("重量(克)").blank? ? 18 : title_row.index("重量(克)")

	            2.upto(instance.last_row) do |line|
	            	# byebug
	  		
	            	zone_id = nil
	              current_line = line
	              rowarr = instance.row(line)
	              express_no = rowarr[express_no_index].blank? ? "" : rowarr[express_no_index].to_s.split('.0')[0]
	              country = rowarr[country_index].blank? ? "" : rowarr[country_index].to_s
	              business_code = rowarr[business_code_index].blank? ? "" : rowarr[business_code_index].to_s.split('.0')[0]
	              posting_date = rowarr[posting_date_index].blank? ? nil : DateTime.parse(rowarr[posting_date_index].to_s.split(".0")[0]).strftime('%Y-%m-%d')
	              receiver_postcode = rowarr[receiver_postcode_index].blank? ? "" : rowarr[receiver_postcode_index].to_s.split('.0')[0]
	              weight = rowarr[weight_index].blank? ? 0.00 : rowarr[weight_index].to_f

	              if express_no.blank?
	                is_error = true
	                txt = "缺少邮件号"
	                sheet_error << (rowarr << txt)
	                next
	              else
		              if express_nos.include?express_no
		              	is_error = true
		                txt = "邮件号重复"
		                sheet_error << (rowarr << txt)
		                next
		              else
		              	express_nos << express_no
		              end
		            end

		            if country.blank?
		            	is_error = true
	                txt = "缺少寄达国（地区）"
	                sheet_error << (rowarr << txt)
	                next
	              else
		              if !(Country.find(selected_country_id).name.eql?country)
		              	is_error = true
		                txt = "寄达国（地区）与选择的国家不一致"
		                sheet_error << (rowarr << txt)
		                next
		              end
		            end

		            if business_code.blank?
		            	is_error = true
	                txt = "缺少大宗客户代码"
	                sheet_error << (rowarr << txt)
	                next
	              else
	              	business = Business.find_by(code: business_code, is_international: true)
	              	if business.blank?
	              		is_error = true
		                txt = "未找到该大宗客户"
		                sheet_error << (rowarr << txt)
		                next
		              end
	              end

	              if posting_date.blank?
		            	is_error = true
	                txt = "缺少收寄时间"
	                sheet_error << (rowarr << txt)
	                next
	              end

		            if receiver_postcode.blank?
		            	is_error = true
	                txt = "缺少收件人邮编"
	                sheet_error << (rowarr << txt)
	                next
	              else
	              	zones = ReceiverZone.where(country_id: selected_country_id).map{|z| [z.id, z.start_postcode, z.end_postcode]}
	              	zone_id = get_zone(receiver_postcode, zones)
	              	if zone_id.blank?
	              		is_error = true
		                txt = "未找到收件人邮编对应地区"
		                sheet_error << (rowarr << txt)
		                next
		              end
	              end

	              # sheet_error << (rowarr << txt)
		    #  Rails.logger.error express_no
	              international_express = InternationalExpress.create! express_no: express_no, country_id: selected_country_id, business_id: business.id, posting_date: posting_date, receiver_postcode: receiver_postcode, weight: weight, receiver_zone_id: zone_id, import_file_id: import_file.id, status: "waiting", is_arrived: false, is_leaved: false, is_leaved_orig: false, is_leaved_center: false, is_takeoff: false
	              international_express.refresh_traces_by_mail_trace!
	            end
	          rescue Exception => e
	            trans_error = true
	            message = e.message + "(第" + current_line.to_s + "行)"

	            puts e.message
	            puts e.backtrace
					    Rails.logger.error("#{e.class.name} #{e.message}")
					    e.backtrace.each{|x| Rails.logger.error(x)}    
		    
		    			raise ActiveRecord::Rollback
	          end

	          if trans_error
				      import_file.update status: "fail", desc: message
				    elsif !sheet_error.blank?
				      filename = "Error_International_Express_Infos_#{Time.now.strftime('%Y%m%d %H:%M:%S')}.xls"
				      err_file_path = "#{Rails.root}/upload/international_express_info/" + filename
				         
				      exporterrorinternational_express_infos_xls_content_for(sheet_error, title_row, err_file_path)

				      if sheet_error.size == (row_count - 1)
				      	message = "失败"
				        import_file.update status: "fail", desc: message, err_file_path: err_file_path
				      else
				      	message = "部分导入成功,共#{sheet_error.size}行失败"
				        import_file.update status: "success", desc: message, err_file_path: err_file_path
				      end
				    else
				    	message = "成功"
				      import_file.update status: "success", desc: message
				    end
				    if message.include?"成功"
				    	flash[:notice] = message
				    else
				    	flash[:alert] = message
				    end
	        end
	      end
	    end
    end           
  end

  def exporterrorinternational_express_infos_xls_content_for(obj,title_row,file_path)
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "International_Expresses"  

    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10  
    red = Spreadsheet::Format.new :color => :red
    sheet1.row(0).default_format = blue 
    # sheet1.row(0).concat %w{可售卖产品 邮件号 寄件人 寄达国（地区） 寄达省名称 寄达市名称 大宗客户代码 大宗客户名称 子客户编码 子客户名称 收寄员 收寄时间 运输方式 收件人 收件人电话 收件人邮编 收件人地址 本机构格口 重量(克) 总邮资 标准邮资 实收邮资 其他邮资 保费金额 结算方式 收寄来源 体积 长 宽 高 保价保险标志 最后修改时间} 
    sheet1.row(0).concat title_row
    size = obj.first.size 
    count_row = 1
    obj.each do |obj|
      count = 0
      while count<=size
        sheet1[count_row,count]=obj[count]
        count += 1
      end
      
      count_row += 1
    end 
    book.write file_path  
  end

  def get_zone(receiver_postcode, zones)
  	zone_id = nil
  	code = receiver_postcode[0,3]

  	zones.each do |x|
  		if (receiver_postcode.to_i >= x[1].to_i) && (receiver_postcode.to_i <= x[2].to_i)
  			zone_id = x[0]
  			break
  		end
  	end

  	return zone_id
  end

  def get_mail_trace
    @traces = []
    mailtrace = MailTrace.find_by(mail_no: @international_express.express_no)
    if !mailtrace.blank?
      @traces = mailtrace.traces.split(/\n/)
    end
  end

  private
  	def upload_international_express_info(file)
  		if !file.original_filename.empty?
  			direct = "#{Rails.root}/upload"
  			if !File.exist?(direct)
			    Dir.mkdir(direct)          
				end
				direct += "/international_express_info/"
  			if !File.exist?(direct)
			    Dir.mkdir(direct)          
				end
        filename = "#{Time.now.to_f}_#{file.original_filename}"
        file_path = direct + filename
        File.open(file_path, "wb") do |f|
           f.write(file.read)
        end
        file_path
      end
    end

    def get_batch_no
    	bno = ImportFile.last.blank? ? "1" : (ImportFile.last.batch_no.blank? ? "1" : (ImportFile.last.batch_no.to_i+1).to_s)
    end
end
