# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  # include CarrierWave::Uploader::MagicMimeWhitelist

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "attachments/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Override the directory where cache files are uploaded
  def cache_dir
    'attachments/tmp/cache'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(PDF DOC DOCX XLSX PPTX CSV ICS)
  end

  # TODO: get this working! See https://www.pivotaltracker.com/n/projects/1262572/stories/104431742
  #  To avoid spoofing also whitelist content mime type
  # def whitelist_mime_type_pattern
  #   /(application\/(pdf|vnd.openxmlformats-officedocument.wordprocessingml.document|vnd.openxmlformats-officedocument.spreadsheetml.sheet|vnd.openxmlformats-officedocument.presentationml.presentation)|text\/csv)/
  # end

  # Move from cache when item is saved so as to not double consume storage
  def move_to_store
    true
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
