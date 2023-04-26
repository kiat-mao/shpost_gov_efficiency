class ReceiverZonesController < ApplicationController
  load_and_authorize_resource :receiver_zone

  # GET /receiver_zones
  # GET /receiver_zones.json
  def index
    # @receiver_zones = ReceiverZone.all
    @receiver_zones_grid = initialize_grid(@receiver_zones, :per_page => params[:page_size])
  end

  # GET /receiver_zones/1
  # GET /receiver_zones/1.json
  def show
  end

  # GET /receiver_zones/new
  def new
    # @receiver_zones = ReceiverZone.new
  end

  # GET /receiver_zones/1/edit
  def edit
  end

  # POST /receiver_zones
  # POST /receiver_zones.json
  def create
    respond_to do |format|
      if @receiver_zone.save
        format.html { redirect_to @receiver_zone, notice: I18n.t('controller.create_success_notice', model: '寄达国分区')}
        format.json { render action: 'show', status: :created, location: @receiver_zone }
      else
        format.html { render action: 'new' }
        format.json { render json: @receiver_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receiver_zones/1
  # PATCH/PUT /receiver_zones/1.json
  def update
    respond_to do |format|
      if @receiver_zone.update(receiver_zone_params)
        format.html { redirect_to @receiver_zone, notice: I18n.t('controller.update_success_notice', model: '寄达国分区') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @receiver_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receiver_zones/1
  # DELETE /receiver_zones/1.json
  def destroy
    @receiver_zone.destroy
    
    respond_to do |format|
      format.html { redirect_to receiver_zones_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receiver_zone
      @receiver_zone = ReceiverZone.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def receiver_zone_params
      params.require(:receiver_zone).permit(:zone, :country_id, :start_postcode, :end_postcode)
    end
end
