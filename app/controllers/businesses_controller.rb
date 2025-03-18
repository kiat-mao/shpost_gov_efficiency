class BusinessesController < ApplicationController
  load_and_authorize_resource :business

  # GET /businesses
  # GET /businesses.json
  def index
    # @businesses = Business.all
    @businesses_grid = initialize_grid(@businesses, :per_page => params[:page_size])
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    # @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    respond_to do |format|
      if current_user.international?
        @business.is_international = true 
      end
      if params[:btype].blank?
        @business.btype="其他"
      end
      if params[:industry].blank?
        @business.industry="其他"
      end
     
      if @business.save
        format.html { redirect_to @business, notice: I18n.t('controller.create_success_notice', model: '商户')}
        format.json { render action: 'show', status: :created, location: @business }
      else
        format.html { render action: 'new' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      @business.code = business_params[:code]
      @business.name = business_params[:name]

      if business_params[:btype].blank?
        @business.btype="其他"
      else
        @business.btype = business_params[:btype]
      end
      if business_params[:industry].blank?
        @business.industry="其他"
      else
        @business.industry = business_params[:industry]
      end
      @business.time_limit = business_params[:time_limit]
      @business.is_init_expresses_midday = eval(business_params[:is_init_expresses_midday])
      @business.is_all_visible = eval(business_params[:is_all_visible])
      @business.static_alert = eval(business_params[:static_alert])
    
      # if @business.update(business_params)
      if @business.save
        format.html { redirect_to @business, notice: I18n.t('controller.update_success_notice', model: '商户') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    
    respond_to do |format|
      format.html { redirect_to businesses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:code, :name, :btype, :industry, :time_limit, :is_init_expresses_midday, :is_all_visible, :static_alert)
    end
end
