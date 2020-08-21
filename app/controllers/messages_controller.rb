class MessagesController < ApplicationController
  load_and_authorize_resource :message

  # GET /messages
  # GET /messages.json
  def index
    @messages_grid = initialize_grid(@messages, :per_page => params[:page_size])
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    # @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    role_arr = []
    roles = ""
    if !params[:checkbox_role].blank?
      params[:checkbox_role].each do |x|     
        if x[1].eql?"1"   
          role_arr << x[0]
        end
      end
      roles = role_arr.compact.join(",")
    end
    if !roles.blank?
      @message.roles = roles
    end

    respond_to do |format|
      if @message.save
        UserMessage.create message_id: @message.id, user_id: User.find_by(role: "superadmin").id if !User.find_by(role: "superadmin").blank?
        format.html { redirect_to @message, notice: I18n.t('controller.create_success_notice', model: '消息')}
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    role_arr = []
    roles = ""
    if !params[:checkbox_role].blank?
      params[:checkbox_role].each do |x|     
        if x[1].eql?"1"   
          role_arr << x[0]
        end
      end
      roles = role_arr.compact.join(",")
    end
    if !roles.blank?
      @message.roles = roles
    end

    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: I18n.t('controller.update_success_notice', model: '消息') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def details
    @message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:title, :content, :start_time, :end_time, :roles)
    end
end
