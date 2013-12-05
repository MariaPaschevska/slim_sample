module SessionsHelper
	def sign_in(user)
	#to place a remember token as a cookie on the user’s browser, and then use the token to find the user record in the database as the user moves from page to page 
    cookies.permanent[:remember_token] = user.remember_token   
    #to create current_user, accessible in both controllers and views 
    self.current_user = user
  end

  #a user is signed in if current_user is not nil
  def signed_in?
    !current_user.nil?
  end

  #defines a method current_user= 
  def current_user=(user)
  	#sets an instance variable @current_user, effectively storing the user for later use
    @current_user = user
  end

  def current_user
  	#to set the @current_user instance variable to the user corresponding to the remember token, but only if @current_user is undefined
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
  	#set the current user to nil 
    self.current_user = nil
    #use the delete method on cookies to remove the remember token from the session
    cookies.delete(:remember_token)
  end

  # friendly forwarding  - store the location of the requested page somewhere, and then redirect to that location instead
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # The store_location method puts the requested URI in the session variable under the key :return_to.
  def store_location
    session[:return_to] = request.url
  end
end
