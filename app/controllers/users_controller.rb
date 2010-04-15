class UsersController < ApplicationController
  before_filter :require_user
  
  def index
    @page, offset = page_and_offset
    @users = User.all(:limit => ONBOX_CONFIG[:default_table_size], :offset => offset, :order => "login")
    @user_count = User.count  
  end
  
  def new
    @user = User.new
    render :save
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to users_url
    else
      render :action => :save
    end
  end

  def edit
    @user = User.find(params[:id])
    render :save
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to users_url
    else
      render :action => :save
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    flash[:notice] = "'#{@user.login}' was removed."    
    @user.destroy
    redirect_to(users_url)
  end
end
