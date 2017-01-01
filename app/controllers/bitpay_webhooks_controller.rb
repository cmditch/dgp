class BitpayWebhooksController < ApplicationController
  before_action :set_bitpay_webhook, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  # GET /bitpay_webhooks
  # GET /bitpay_webhooks.json
  def index
    @bitpay_webhooks = BitpayWebhook.all
  end

  # GET /bitpay_webhooks/1
  # GET /bitpay_webhooks/1.json
  def show
  end

  # GET /bitpay_webhooks/new
  def new
    @bitpay_webhook = BitpayWebhook.new
  end

  # GET /bitpay_webhooks/1/edit
  def edit
  end

  # POST /bitpay_webhooks
  # POST /bitpay_webhooks.json
  def create
    @bitpay_webhook = BitpayWebhook.new(bitpay_webhook_params)

    respond_to do |format|
      if @bitpay_webhook.save
        format.html { redirect_to @bitpay_webhook, notice: 'Bitpay webhook was successfully created.' }
        format.json { render :show, status: :created, location: @bitpay_webhook }
      else
        format.html { render :new }
        format.json { render json: @bitpay_webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bitpay_webhooks/1
  # PATCH/PUT /bitpay_webhooks/1.json
  def update
    respond_to do |format|
      if @bitpay_webhook.update(bitpay_webhook_params)
        format.html { redirect_to @bitpay_webhook, notice: 'Bitpay webhook was successfully updated.' }
        format.json { render :show, status: :ok, location: @bitpay_webhook }
      else
        format.html { render :edit }
        format.json { render json: @bitpay_webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bitpay_webhooks/1
  # DELETE /bitpay_webhooks/1.json
  def destroy
    @bitpay_webhook.destroy
    respond_to do |format|
      format.html { redirect_to bitpay_webhooks_url, notice: 'Bitpay webhook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    # POST /bitpay.json
  def receive
    BitpayWebhook.create(data: params)
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bitpay_webhook
      @bitpay_webhook = BitpayWebhook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def bitpay_webhook_params
    #   params.require(:bitpay_webhook).permit(
    #       :data,
    #       :invoice_id,
    #       :amount,
    #       :btcPaid,
    #       :posData,
    #       :currency,
    #       :rate,
    #       :status,
    #       :exceptionStatus
    #     )
    # end
end
