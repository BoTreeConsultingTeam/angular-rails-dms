class Upload < ActiveRecord::Base

  belongs_to :user
  has_many :shares

  has_attached_file :file,
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                    :dropbox_visibility => 'public'

  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

end
