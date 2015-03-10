class WelcomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    @upload = Upload.new
    @my_uploads = current_user.uploads
    @shared_uploads = current_user.shares
    @all_users = User.all.where("id != ?", current_user.id).pluck(:name,:id)
    @user_documents = current_user.uploads.pluck(:file_file_name, :id)
  end

  def get_files
    my_uploads_hash = []
    shared_uploads_hash = []
    my_uploads = current_user.uploads
    shared_uploads = current_user.shares
    my_uploads.each{|u| my_uploads_hash << {id: u.id, name: (u.file.instance_read(:file_name)), url: "#{(u.file.url)}"}} rescue nil
    shared_uploads.each{|s| shared_uploads_hash << {id: s.upload_id, name: (s.upload.file.instance_read(:file_name)), url: "#{(s.upload.file.url)}"}} rescue nil
    render json: {
        my_uploads: my_uploads_hash,
        shared_uploads:shared_uploads_hash
    }
  end

  def share_multiple_documents
    if params[:documents].present? && params[:users].present?
      params[:documents].each do |document_id|
        params[:users].each do |user_id|
          Share.find_or_create_by(upload_id: document_id, user_id: user_id)
        end
      end

      @all_users = User.all.where("id != ?", current_user.id).pluck(:name,:id)
      @user_documents = current_user.uploads.pluck(:file_file_name, :id)
      respond_to do |format|
        format.js
      end
    end
  end

end
