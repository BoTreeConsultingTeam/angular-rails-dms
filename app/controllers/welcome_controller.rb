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

    my_uploads.each do |u|
      if File.extname(u.file.url).eql?('.png')
        thumb_file_url = u.file.url(:thumb)
      else
        thumb_file_url = File.dirname(u.file.url(:thumb)) + '/' + File.basename(u.file.url(:thumb), File.extname(u.file.url(:thumb))) + '.png'
      end
      if((u.file.instance_read(:file_name)).length > 30)
        file_name = (u.file.instance_read(:file_name))[0..30]
      else
        file_name = (u.file.instance_read(:file_name))
      end
      my_uploads_hash << {id: u.id, name: file_name, original_url: "#{(u.file.url)}", thumb_url: thumb_file_url}
    end rescue nil

    shared_uploads.each do |s|
      if File.extname(s.upload.file.url).eql?('.png')
        thumb_file_url = s.upload.file.url(:thumb)
      else
        thumb_file_url = File.dirname(s.upload.file.url(:thumb)) + '/' + File.basename(s.upload.file.url(:thumb), File.extname(s.upload.file.url(:thumb))) + '.png'
      end
      if((s.upload.file.instance_read(:file_name)).length > 30)
        file_name = (s.upload.file.instance_read(:file_name))[0..30]
      else
        file_name = (s.upload.file.instance_read(:file_name))
      end
      shared_uploads_hash << {id: s.upload_id, name: file_name, original_url: "#{(s.upload.file.url)}", thumb_url: thumb_file_url}
    end rescue nil

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
