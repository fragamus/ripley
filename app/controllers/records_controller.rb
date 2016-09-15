class RecordsController < ApplicationController
  before_action :set_record, only: [:show]

  # GET /records/1
  # GET /records/1.json
  def show
    @things = @record.things
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end
end
