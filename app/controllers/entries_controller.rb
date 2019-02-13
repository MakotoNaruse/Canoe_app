class EntriesController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def index
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
  end

  def add
    @entry = Entry.new
    @entry.race_name = params[:race_name]
    @entry.player_id = params[:entry][:player_id]
    flash[:notice] = @entry
    if @entry.save
      flash[:notice] = "エントリーを登録しました"
    else
      flash[:notice] = "エントリーを登録できませんでした"
    end
    redirect_to("/entries/index")
  end

  def destroy
    @entry = Entry.find_by(id: params[:id])
    @entry.destroy
    flash[:notice] = "選手を削除しました"
    redirect_to("/entries/index")
  end

end
