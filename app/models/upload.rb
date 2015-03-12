class Upload < ActiveRecord::Base

  belongs_to :user
  has_many :shares

  has_attached_file :file,
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension",
                    :styles => {:thumb => { geometry: '200x200>', format: :png }},
                    :use_timestamp => false

  before_post_process :is_image
  after_save :create_thumb_for_other_docs

  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

  def create_thumb_only_for_image
    return false unless (file_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$})
  end

  def is_image
    create_thumb_only_for_image.nil? ? true : false
  end

  def is_pdf
    file_content_type.eql?('application/pdf')
  end

  private

  def create_thumb_for_other_docs
    return if is_image
    create_pdf unless is_image || is_pdf

    saved_file_path = Rails.root.to_s + '/public' + file.url[0..(file.url.index('original')-2)]
    Dir.chdir(saved_file_path)
    Dir.mkdir('thumb')
    Dir.chdir('thumb')
    magick.scale(300, 300).write(thumb_file_name)
  end

  def create_pdf
    Dir.chdir( "#{Rails.root}" + '/public' + file_dir)
    Libreconv.convert(file_name_with_extn, file_name_without_extn + '.pdf')
  end

  def magick
    Magick::ImageList.new(saved_file)
  end

  def saved_file
    File.open("#{Rails.root}" + '/public' + "#{file_dir}" + '/' + "#{file_name_without_extn}" + '.pdf')
  end

  def file_dir
    File.dirname(file.url)
  end

  def file_extn
    File.extname(file.url)
  end

  def file_name_with_extn
    File.basename(file.url)
  end

  def file_name_without_extn
    File.basename(file.url, file_extn)
  end

  def thumb_file_name
    File.basename(file.url,(File.extname(file.url))) + '.png'
  end
end
