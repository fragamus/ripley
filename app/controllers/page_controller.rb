class PageController < ApplicationController
  def query

  end

  def details
    @records = Record.find_gonzo(params[:name],params[:ssn],"").each{|x|p x}
  end

end
