class ExpressesController < ApplicationController
  load_and_authorize_resource :express

  # GET /expresses
  # GET /expresses.json
  def index
    @need_alert = params[:need_alert]
    @undelivered_nextday = params[:undelivered_nextday]

    if (params[:industry].is_a?String) && (params[:industry].include?",")
      params[:industry] = params[:industry].split(",")
    end

    @expresses = Report.get_filter_expresses(params).accessible_by(current_ability)
    @expresss_grid = initialize_grid(@expresses, :per_page => params[:page_size],
      name: 'expresses',
      :enable_export_to_csv => true,
      :csv_file_name => 'expresses',
      :csv_encoding => 'gbk')
    export_grid_if_requested
  end

  def zm_province_index
    @expresses = Report.get_filter_expresses(params).accessible_by(current_ability)
    @expresss_grid = initialize_grid(@expresses, :per_page => params[:page_size],
      name: 'zm_province_expresses',
      :enable_export_to_csv => true,
      :csv_file_name => 'zm_province_expresses',
      :csv_encoding => 'gbk')
    export_grid_if_requested
  end

  # GET /expresses/1
  # GET /expresses/1.json
  def show
  end

  # GET /expresses/new
  def new
    @express = Express.new
  end

  # GET /expresses/1/edit
  def edit
  end

  # POST /expresses
  # POST /expresses.json
  def create
    @express = Express.new(express_params)

    respond_to do |format|
      if @express.save
        format.html { redirect_to @express, notice: 'Express was successfully created.' }
        format.json { render :show, status: :created, location: @express }
      else
        format.html { render :new }
        format.json { render json: @express.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expresses/1
  # PATCH/PUT /expresses/1.json
  def update
    respond_to do |format|
      if @express.update(express_params)
        format.html { redirect_to @express, notice: 'Express was successfully updated.' }
        format.json { render :show, status: :ok, location: @express }
      else
        format.html { render :edit }
        format.json { render json: @express.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expresses/1
  # DELETE /expresses/1.json
  def destroy
    @express.destroy
    respond_to do |format|
      format.html { redirect_to expresses_url, notice: 'Express was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_mail_trace
    @traces = []
    mailtrace = MailTrace.find_by(mail_no: @express.express_no)
    if !mailtrace.blank?
      @traces = mailtrace.traces.split(/\n/)
    end
  end

  # def receiver_query
    
  # end

  # 单个轨迹信息查询
  def query_mail_trace
    @traces = []
   
    if !params[:mail_no].blank?
      # 查当前库
      mailtrace = MailTrace.find_by(mail_no: params[:mail_no])
      if !mailtrace.blank?
        @traces = mailtrace.traces.split(/\n/)
        return
      end
      # 查历史库
      year = (params[:year].start_with?"2023") ? "2023" : params[:year]
      mailtrace = MailTraceHis.find_by_year(year, params[:mail_no])
      if !mailtrace.blank?
        @traces = MailTraceHis.traces(year, mailtrace.id).split(/\n/)
      else
        flash[:alert] = "无信息!"
      end
    end
  end


  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_express
      @express = Express.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def express_params
      params.fetch(:express, {})
    end
end
