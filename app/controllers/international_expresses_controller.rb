class InternationalExpressesController < ApplicationController
  load_and_authorize_resource :international_express
  # require 'roo'

  def import
  	unless request.get?
  		if file = upload_international_express_info(params[:file]['file'])       
        ActiveRecord::Base.transaction do
          begin
          	selected_country_id = params[:country].to_i
          	express_nos = []
          	sheet_error = []
            rowarr = [] 
            instance=nil
            flash_message = "导入成功!"
            current_line = 0
            is_error = false

            if file.include?('.xlsx')
              instance= Roo::Excelx.new(file)
            elsif file.include?('.xls')
              instance= Roo::Excel.new(file)
            elsif file.include?('.csv')
              instance= Roo::CSV.new(file)
            end
            instance.default_sheet = instance.sheets.first
            title_row = instance.row(1)
            express_no_index = title_row.index("邮件号").blank? ? 1 : title_row.index("邮件号")
            country_index = title_row.index("寄达国（地区）").blank? ? 3 : title_row.index("寄达国（地区）")
            business_code_index = title_row.index("大宗客户代码").blank? ? 6 : title_row.index("大宗客户代码")
            posting_date_index = title_row.index("收寄时间").blank? ? 11 : title_row.index("收寄时间")
            receiver_postcode_index = title_row.index("收件人邮编").blank? ? 15 : title_row.index("收件人邮编")
            weight_index = title_row.index("重量(克)").blank? ? 18 : title_row.index("重量(克)")

            2.upto(instance.last_row) do |line|
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
	              if !(CountryTimeLimit.find(selected_country_id).country.eql?country)
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
              	business = Business.find_by(code: business_code)
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
              end

              sheet_error << (rowarr << txt)

              InternationalExpress.create! express_no: express_no, country_time_limit_id: selected_country_id, business_id: business.id, posting_date: posting_date, receiver_postcode: receiver_postcode, weight: weight, zone_id: get_zone(receiver_postcode, selected_country_id)
            end

            # if !sheet_error.blank?
            if is_error
              flash_message << "有部分信息导入失败！"
            end
            flash[:notice] = flash_message

            # if !sheet_error.blank?
            if is_error
              send_data(exporterrorinternational_express_infos_xls_content_for(sheet_error,title_row),  
              :type => "text/excel;charset=utf-8; header=present",  
              :filename => "Error_International_Express_Infos_#{Time.now.strftime("%Y%m%d")}.xls")  
            else
              redirect_to :action => 'import'
            end

          rescue Exception => e
            Rails.logger.error e.backtrace
            flash[:alert] = e.message + "第" + current_line.to_s + "行"
            raise ActiveRecord::Rollback
          end
        end
      end
    end           
  end

  def get_zone(receiver_postcode, selected_country_id)
  	zone_id = nil
  	code = receiver_postcode.split("-")[0]

  	ReceiverZone.where(country_time_limit_id: selected_country_id).each do |x|
  		if (receiver_postcode.to_i >= x.start_postcode.to_i) && (receiver_postcode.to_i <= x.end_postcode.to_i)
  			zone_id = x.id
  			break
  		end
  	end

  	return zone_id
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
end