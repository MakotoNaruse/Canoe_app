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
  end


  def top
  end

  def accounts_index
    @universities = University.all
  end

  def accounts_add
    @university = University.new(
      u_name: params[:u_name],
      read: params[:read],
      erea: params[:erea],
      password: params[:password]
    )
    if @university.save
      flash[:notice] = "アカウントを追加しました。"
    else
      flash[:notice] = "アカウントを追加できませんでした。内容を確認してください。"
    end
    redirect_to("/operations/accounts/index")
  end

  def accounts_edit
    @university = University.find_by(id: params[:id])
    if @university == nil
      flash[:notice] = "大学が存在しません"
      redirect_to("/operations/accounts/index")
    end
  end

  def accounts_update
    @university = University.find_by(id: params[:id])
    @university.u_name = params[:u_name]
    @university.read= params[:read]
    @university.erea = params[:erea]
    @university.password = params[:password]
    if @university.save
      flash[:notice] = "大学アカウント情報を変更しました。"
      redirect_to("/operations/accounts/index")
    else
      flash[:notice] = "変更できませんでした。内容を確認してください。"
      render("operations/accounts_edit")
    end
  end

end
