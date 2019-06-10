class ApplicationController < ActionController::Base

  before_action :access_count

  def access_count
    op = Operation.find(1)
    op.command = op.command.to_i + 1
    op.save
  end
  
end
