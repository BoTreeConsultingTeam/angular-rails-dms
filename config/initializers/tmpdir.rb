require 'fileutils'

# force the whole app to use its own tmpdir
FileUtils.mkdir_p(Rails.root.join('tmp'))
ENV['TMPDIR'] = Rails.root.join('tmp').to_s