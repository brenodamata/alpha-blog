class	SessionsController < ApplicationController

	def new

	end

	def create
		user = User.find_by_email(params[:session][:login])
		
		user = User.find_by(username: params[:session][:login]) unless user
		
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
      	session[:user_id] = user.id
        flash[:success] = "Welcome back #{user.username}."
        format.html { redirect_to user }
        format.json { render :show, status: :created, location: user }
      else
				flash.now[:danger] = "Login failed."
        format.html { render :new }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end

	end

	def destroy
		session[:user_id] = nil
		flash[:info] = "You have taken the Blue Pill."
		redirect_to root_path
	end

end