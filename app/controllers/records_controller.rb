class RecordsController < ApplicationController

  before_action :authenticate_user!

  before_action :set_record, only: [:show]

  # GET /records/1
  # GET /records/1.json
  def show
    @things = @record.things
    numThings = @things.to_a.map{|x|x.h}.uniq.length
    if numThings == 1 then
        @thing=@things.first
        tiff = @thing.path
        @pdf = Rails.root.join("public", @thing.h+".pdf")
        success = system("tiff2pdf", tiff, "-o", @pdf.to_s)
        send_file(@pdf, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end
end
