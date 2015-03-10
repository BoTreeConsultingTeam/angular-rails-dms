class Upload < ActiveRecord::Base

  belongs_to :user
  has_many :shares

  has_attached_file :file,
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png', 'application/pdf']

end
