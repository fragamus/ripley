class ThingsController < ApplicationController
  before_action :set_thing, only: [:show]

  # GET /things/1
  # GET /things/1.json
  def show
    tiff = @thing.path
    @pdf = Rails.root.join("public", @thing.h+".pdf")
    success = system("tiff2pdf", tiff, "-o", @pdf.to_s)
    send_file(@pdf, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      @thing = Thing.find(params[:id])
    end
end
