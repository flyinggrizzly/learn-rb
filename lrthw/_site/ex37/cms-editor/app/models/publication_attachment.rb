class PublicationAttachment < ActiveRecord::Base
  belongs_to :publication
  has_paper_trail

  # TODO: Validate attachment is allowed content type
  # See https://www.pivotaltracker.com/n/projects/1262572/stories/104431742
  mount_uploader :attachment, AttachmentUploader, mount_on: :attachment_filename

  default_scope { order('created_at ASC') }
end
