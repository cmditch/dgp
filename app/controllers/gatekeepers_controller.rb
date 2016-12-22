class GatekeepersController < ApplicationController
  before_action :set_gatekeeper, only: [:show, :edit, :update, :destroy]

  # GET /gatekeepers
  # GET /gatekeepers.json
  def index
    @gatekeepers = Gatekeeper.all
  end

  # GET /gatekeepers/1
  # GET /gatekeepers/1.json
  def show
  end

  # GET /gatekeepers/new
  def new
    @gatekeeper = Gatekeeper.new
  end

  # GET /gatekeepers/1/edit
  def edit
  end

  # POST /gatekeepers
  # POST /gatekeepers.json
  def create
    @gatekeeper = Gatekeeper.new(gatekeeper_params)

    respond_to do |format|
      if @gatekeeper.save
        format.html { redirect_to @gatekeeper, notice: 'Gatekeeper was successfully created.' }
        format.json { render :show, status: :created, location: @gatekeeper }
      else
        format.html { render :new }
        format.json { render json: @gatekeeper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gatekeepers/1
  # PATCH/PUT /gatekeepers/1.json
  def update
    respond_to do |format|
      if @gatekeeper.update(gatekeeper_params)
        format.html { redirect_to @gatekeeper, notice: 'Gatekeeper was successfully updated.' }
        format.json { render :show, status: :ok, location: @gatekeeper }
      else
        format.html { render :edit }
        format.json { render json: @gatekeeper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gatekeepers/1
  # DELETE /gatekeepers/1.json
  def destroy
    @gatekeeper.destroy
    respond_to do |format|
      format.html { redirect_to gatekeepers_url, notice: 'Gatekeeper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gatekeeper
      @gatekeeper = Gatekeeper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gatekeeper_params
      params.require(:gatekeeper).permit(:name)
    end
end
