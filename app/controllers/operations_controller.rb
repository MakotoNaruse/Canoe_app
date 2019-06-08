class OperationsController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
    if @current_op.id == 2 || @current_op.id == 5
      @tour = 1
    elsif @current_op.id == 3 || @current_op.id == 6
      @tour = 2
    elsif @current_op.id == 4 || @current_op.id == 7
      @tour = 3
    end
  end


  def top
  end

  def substitutes
    @substitutes = Substitute.where(year: @year).where(tour: @tour)
  end

  def entry_time
    @op = Operation.all
  end

  def entry_time_change
    begin
      # 日付が違う場合は以下でArgumentErrorが発生
      start = DateTime.new(@year, params[:start_mounth].to_i, params[:start_day].to_i, params[:start_hour].to_i, params[:start_minute].to_i, 0, 0.375)
      finish = DateTime.new(@year, params[:finish_mounth].to_i, params[:finish_day].to_i, params[:finish_hour].to_i, params[:finish_minute].to_i, 0, 0.375)
      if @tour == 1
        op = Operation.find(2)
        op.command = params[:start_mounth]
        op.save
        op = Operation.find(3)
        op.command = params[:start_day]
        op.save
        op = Operation.find(4)
        op.command = params[:start_hour]
        op.save
        op = Operation.find(5)
        op.command = params[:start_minute]
        op.save
        op = Operation.find(14)
        op.command = params[:finish_mounth]
        op.save
        op = Operation.find(15)
        op.command = params[:finish_day]
        op.save
        op = Operation.find(16)
        op.command = params[:finish_hour]
        op.save
        op = Operation.find(17)
        op.command = params[:finish_minute]
        op.save
      end
      if @tour == 2
        op = Operation.find(6)
        op.command = params[:start_mounth]
        op.save
        op = Operation.find(7)
        op.command = params[:start_day]
        op.save
        op = Operation.find(8)
        op.command = params[:start_hour]
        op.save
        op = Operation.find(9)
        op.command = params[:start_minute]
        op.save
        op = Operation.find(18)
        op.command = params[:finish_mounth]
        op.save
        op = Operation.find(19)
        op.command = params[:finish_day]
        op.save
        op = Operation.find(20)
        op.command = params[:finish_hour]
        op.save
        op = Operation.find(21)
        op.command = params[:finish_minute]
        op.save
      end
      if @tour == 3
        op = Operation.find(10)
        op.command = params[:start_mounth]
        op.save
        op = Operation.find(11)
        op.command = params[:start_day]
        op.save
        op = Operation.find(12)
        op.command = params[:start_hour]
        op.save
        op = Operation.find(13)
        op.command = params[:start_minute]
        op.save
        op = Operation.find(22)
        op.command = params[:finish_mounth]
        op.save
        op = Operation.find(23)
        op.command = params[:finish_day]
        op.save
        op = Operation.find(24)
        op.command = params[:finish_hour]
        op.save
        op = Operation.find(25)
        op.command = params[:finish_minute]
        op.save
      end
      flash[:notice] = "エントリー期間を変更しました"
      redirect_to("/operations/entry_time")
    rescue ArgumentError => ex
      flash[:notice] = "入力された日付と時刻が正しくありません"
      redirect_to("/operations/entry_time")
    end
  end

end
