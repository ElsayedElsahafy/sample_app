class UsersController < ApplicationController
  
   before_action :signed_in_user, only: [:index, :edit, :update , :destroy , :follower , :following]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user , only: [:destroy]

  def index
  	@users= User.paginate(page: params[:page])
  	
  end
  def new
  	  	@user=User.new
  end
  def show
   	@user=User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

def create
	@user = User.new (user_params)
	if @user.save
		 flash[:success] = "Welcome to the Sample App!"
		redirect_to @user
	else
		render 'new'
	end
end


def edit
	@user=User.find(params[:id])
	
end

def update
	@user=User.find(params[:id])
	if @user.update_attributes(user_params)
		flash[:success] = "profile updated"
		redirect_to @user

	else
			render 'edit'
	end
end

	def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
	
	def signed_in_user
         redirect_to signin_url , notic:"pleas sign in" unless   signed_in? 		
	end

	 def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end	

    def destroy
    	user=User.find(params[:id]).destroy
    	flash[:success]="user deleted"
    	redirect_to users_path
    	
    end
    def admin_user
    	user=User.find(params[:id])
    	redirect_to (root_url) unless user.admin? 
    	
    end
#followers and following actions
     def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def follower
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

end

