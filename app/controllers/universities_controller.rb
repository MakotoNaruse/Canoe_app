class UniversitiesController < ApplicationController
  before_action :current
  before_action :forbid_login_univ, {only: [:login_form, :login]}
  before_action :forbid_login, {only: [:top, :confirm, :choice_tour_form, :choice]}
  before_action :current_tour
  before_action :forbid_choice, {only: [:top, :confirm]}

  def forbid_login_univ
    if @current_univ
      flash[:notice] = "ログイン中です"
      redirect_to("/reg/top")
    end
  end

  def forbid_login
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def forbid_choice
    if session[:tour_id] == nil
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関東" && session[:tour_id].to_i == 2
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関西" && session[:tour_id].to_i == 3
      redirect_to("/reg/choice")
    end
  end

  def current_tour
    @current_tour_id = session[:tour_id].to_i
    if @current_tour_id == 1
      @current_tour = "全日本インカレ"
    elsif @current_tour_id == 2
      @current_tour = "関西インカレ"
    elsif @current_tour_id == 3
      @current_tour = "関東インカレ"
    end
  end

  def login_form
    # @university = University.new
  end

  def choice_tour_form

  end

  def choice
    if params[:tour].to_i >= 1 && params[:tour].to_i <= 3
      session[:tour_id] = params[:tour]
      flash[:notice] = "選択しました"
      redirect_to("/reg/top")
    else
      flash[:notice] = "選択できませんした"
      redirect_to("/reg/choice")
    end
  end

  def login
    @university = University.find_by(u_name: params[:u_name],
                                     password: params[:password])
    if @university
      session[:univ_id] = @university.id
      flash[:notice] = "ログインしました"
      redirect_to("/reg/top")
    else
      @error_message = "大学名またはパスワードが違います"
      @u_name = params[:u_name]
      @password = params[:password]
      render("universities/login_form")
    end
  end

  def logout
    session[:univ_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def top

  end

  def confirm
    @players = Player.where(u_name: @current_univ.u_name, year: @year)
    @fours = Four.where(university_id: @current_univ.id, tour: @current_tour_id)
  end



end
