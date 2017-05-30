class PageController < ApplicationController

  before_action :authenticate_user!

  def query

  end

  def details
    @records = Record.find_gonzo(params[:name],params[:ssn],"").each{|x|p x}
  end

end
