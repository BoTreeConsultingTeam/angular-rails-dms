class WelcomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    @upload = Upload.new
    @my_uploads = current_user.uploads
    @shared_uploads = current_user.shares
    @all_users = User.all.where("id != ?", current_user.id).pluck(:name,:id)
  end

end
