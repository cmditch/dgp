class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy, :toggle, :verify, :activate, :test_deposit]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all.sort_by {|x| x.created_at }
    @spot_price = Global.first.btc_usd_spot_price
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @spot_price = Global.first.btc_usd_spot_price
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    seed = Seed.unused
    @client.attributes = {mnemonic: seed.seed}
    respond_to do |format|
      if @client.save
        seed.update(used: true, client_id: @client.id)
        format.html { redirect_to verify_client_path(@client), notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @client.toggle_activation
    redirect_to :back
  end

  def verify
    @seed = @client.mnemonic
    @spot_price = Global.first.btc_usd_spot_price
  end

  def activate
    @client.activate
    redirect_to clients_path, notice: "#{@client.name.capitalize} is now active!"
  end

  def test_deposit
    @client.test_deposit
    redirect_to( :back, 
    notice: %Q[Test deposit sent to #{@client.name}, #{view_context.link_to("check wallet here", 'https://blockchain.info/address/' + @client.primary_wallet, target: "_blank", style: "text-decoration: underline; color: orange;")} and on their phone.],
    flash: { html_safe: true })
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :gatekeeper_id, :notes, :mnemonic)
    end
end
