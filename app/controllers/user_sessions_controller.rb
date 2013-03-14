class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]
  
  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:username], params[:password], params[:remember])
        if params[:return_to_url].blank?
          format.html { redirect_back_or_to(:root, :notice => 'Login successful.') }
        else
          format.html { redirect_to(params[:return_to_url], :notice => 'Login successful.') }
        end
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { flash.now[:alert] = "Login failed."; render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    logout
    redirect_to(root_path, :notice => 'Logged out!')
  end
end