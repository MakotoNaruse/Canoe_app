class UniversitiesController < ApplicationController
  before_action :current
  before_action :forbid_login_univ, {only: [:login_form, :login]}
  before_action :forbid, {only: [:top, :confirm]}

  def forbid_login_univ
    if @current_univ
      flash[:notice] = "ログイン中です"
      redirect_to("/reg/top")
    end
  end

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def login_form
    # @university = University.new
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
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
    @fours = Four.where(university_id: @current_univ.id)
  end

end
