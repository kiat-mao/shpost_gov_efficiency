class CountryTimeLimitsController < ApplicationController
  load_and_authorize_resource :country_time_limit

  # GET /country_time_limits
  # GET /country_time_limits.json
  def index
    # @country_time_limits = CountryTimeLimit.all
    @country_time_limits_grid = initialize_grid(@country_time_limits, :per_page => params[:page_size])
  end

  # GET /country_time_limits/1
  # GET /country_time_limits/1.json
  def show
  end

  # GET /country_time_limits/new
  def new
    # @country_time_limits = CountryTimeLimit.new
  end

  # GET /country_time_limits/1/edit
  def edit
  end

  # POST /country_time_limits
  # POST /country_time_limits.json
  def create
    respond_to do |format|
      if @country_time_limit.save
        format.html { redirect_to @country_time_limit, notice: I18n.t('controller.create_success_notice', model: '时限')}
        format.json { render action: 'show', status: :created, location: @country_time_limit }
      else
        format.html { render action: 'new' }
        format.json { render json: @country_time_limit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /country_time_limits/1
  # PATCH/PUT /country_time_limits/1.json
  def update
    respond_to do |format|
      if @country_time_limit.update(country_time_limit_params)
        format.html { redirect_to @country_time_limit, notice: I18n.t('controller.update_success_notice', model: '时限') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @country_time_limit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /country_time_limits/1
  # DELETE /country_time_limits/1.json
  def destroy
    @country_time_limit.destroy
    
    respond_to do |format|
      format.html { redirect_to country_time_limits_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country_time_limit
      @country_time_limit = CountryTimeLimit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def country_time_limit_params
      params.require(:country_time_limit).permit(:country, :interchange1, :interchange2, :air, :arrive, :leave)
    end
end
