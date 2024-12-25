class AirMailsController < ApplicationController

	def export
		unless request.get?
			# byebug
			flight_date_start = params[:flight_date_start].blank? ? Date.today : params[:flight_date_start].to_date
			flight_date_end = params[:flight_date_end].blank? ? Date.today+1.day : params[:flight_date_end].to_date+1.day
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

    sheet1[0,0] = "起飞时间:#{params["flight_date_start"]}~#{params["flight_date_end"]}"
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
end