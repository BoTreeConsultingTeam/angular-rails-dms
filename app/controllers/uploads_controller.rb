class UploadsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @upload = current_user.uploads.new(upload_params)
    if @upload.save
      flash[:success] = "Uploaded Successfully.!"
      params[:users].each { |id| @upload.shares.new(user_id: id).save } if params[:users].present?
      redirect_to root_path
    else
      flash[:error] = @upload.errors.full_messages.to_sentence
      @my_uploads = current_user.uploads
      @shared_uploads = current_user.shares
      @all_users = User.all.where("id != ?", current_user.id).pluck(:name,:id)
      render "welcome/index"
    end
  end

  protected

  def upload_params
    params.require(:upload).permit(:file)
  end

end
