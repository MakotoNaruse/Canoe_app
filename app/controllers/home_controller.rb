class HomeController < ApplicationController
  before_action :current

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def top
    @count = Operation.find(1).command
  end
end
