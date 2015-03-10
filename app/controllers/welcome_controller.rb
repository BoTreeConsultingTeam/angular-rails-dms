class WelcomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    @upload = Upload.new
    @my_uploads = current_user.uploads
    @shared_uploads = current_user.shares
    @all_users = User.all.where("id != ?", current_user.id).pluck(:name,:id)
  end

  def get_files
    my_uploads_hash = []
    shared_uploads_hash = []
    my_uploads = current_user.uploads
    shared_uploads = current_user.shares
    my_uploads.each{|u| my_uploads_hash << {id: u.id, name: (u.file.instance_read(:file_name)), url: "http://2c6f5fda.ngrok.com/#{(u.file.url rescue "")}"}} rescue nil
    shared_uploads.each{|s| shared_uploads_hash << {id: s.upload_id, name: (s.upload.file.instance_read(:file_name)), url: "http://2c6f5fda.ngrok.com/#{(s.upload.file.url rescue "")}"}} rescue nil
    render json: {
        my_uploads: my_uploads_hash,
        shared_uploads:shared_uploads_hash
    }
  end

end
