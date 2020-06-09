class ReportsController < ApplicationController
  
  def deliver_market_report
  	authorize! "report", "DeliverMarketReport"

  	@filters = {}
  	expresses = nil
  	@results = nil

  	unless request.get?
  		expresses = Express.left_outer_joins(:business).all
  		# byebug
  		if !params[:industry].blank? && (!params[:industry].eql?"全部")
  			expresses = expresses.where("businesses.industry = ?", params[:industry])
  		end
      @filters["industry"] = params[:industry]
      
      if !params[:btype].blank? && (!params[:btype].eql?"全部")
  			expresses = expresses.where("businesses.btype = ?", params[:btype])
  		end
      @filters["btype"] = params[:btype]
      
      if !params[:business].blank? && !params[:business][:business].blank?
  			expresses = expresses.where("businesses.code like ? or businesses.name like ?", "%#{params[:business][:business]}%", "%#{params[:business][:business]}%")
  		end
      @filters["business"] = params[:business][:business]
      
      if !params[:posting_date_start].blank? && !params[:posting_date_start][:posting_date_start].blank?
        expresses = expresses.where("expresses.posting_date >= ?", to_date(params[:posting_date_start][:posting_date_start]))
        @filters["posting_date_start"] = params[:posting_date_start][:posting_date_start]
      end

      if !params[:posting_date_end].blank? && !params[:posting_date_end][:posting_date_end].blank?
        expresses = expresses.where("expresses.posting_date < ?", to_date(params[:posting_date_end][:posting_date_end]))
        @filters["posting_date_end"] = params[:posting_date_end][:posting_date_end]
      end

      @results = Express.get_deliver_market_result(expresses)

      if !params[:is_query].blank? and params[:is_query].eql?"true"
        render '/reports/deliver_market_report'
      else
        if @results.blank?
          flash[:alert] = "无数据"
          redirect_to :action => 'deliver_market_report'
        else
        	send_data(deliver_market_report_xls_content_for(@filters,@reports),:type => "text/excel;charset=utf-8; header=present",:filename => "投递情况监控报表-市场维度_#{Time.now.strftime("%Y%m%d")}.xls")  
        end
      end

  	end
  end

  def deliver_market_report_xls_content_for(filters,reports)
  	xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "统计表"  
    
    title = Spreadsheet::Format.new :weight => :bold, :size => 18
    filter = Spreadsheet::Format.new :size => 12
    body = Spreadsheet::Format.new :size => 10, :border => :thin, :align => :center

    sheet1.row(0).default_format = filter
    sheet1.row(1).default_format = filter
    sheet1[0,0] = "二级行业名称:#{filters["industry"]}"
    sheet1[0,4] = "客户类别:#{filters["btype"]}"
    sheet1[0,8] = "客户:#{filters["business"]}"
    sheet1[1,0] = "收寄范围：#{filters["posting_date_start"]} - #{filters["posting_date_end"]}"

    sheet1.row(2).default_format = title
    sheet1.row(2).concat %w{行业市场 收寄数 总妥投数 妥投率 三日妥投率 次日妥投率 未妥投总数 未妥投率 退回数 退回率}

    count_row = 3

    reports.each do |k, v|
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
      
      sheet1.row(count_row).default_format = body
      
      count_row += 1
    end

    book.write xls_report  
    xls_report.string

  end

  private
  	def to_date(time)
	    # date = Date.civil(time.split(/-|\//)[0].to_i,time.split(/-|\//)[1].to_i,time.split(/-|\//)[2].to_i)
	    time.to_time
	    # return date
	  end
end