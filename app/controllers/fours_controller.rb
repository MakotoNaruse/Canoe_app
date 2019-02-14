class FoursController < ApplicationController
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
    @fours = Four.where(university_id: @current_univ.id)
  end

  def add
    @search = Four.find_by(
      race_name: params[:race_name],
      university_id: @current_univ.id
    )
    if @search
      flash[:notice] = "すでに登録されています"
    else
      @four = Four.new(
        race_name: params[:race_name],
        university_id: @current_univ.id
      )
      if @four.save
        flash[:notice] = "エントリーを追加しました。"
      else
        flash[:notice] = "エントリーを追加できませんでした。管理者に問い合わせてください。"
      end
    end
    redirect_to("/fours/index")
  end

  def destroy
    @four = Four.find_by(id: params[:id])
    if @four.university_id != @current_univ.id
      flash[:notice] = "権限がありません"
    else
      @four.destroy
      flash[:notice] = "エントリーを削除しました"
    end
    redirect_to("/fours/index")
  end

end
