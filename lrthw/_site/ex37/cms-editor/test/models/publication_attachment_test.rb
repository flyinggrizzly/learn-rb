require 'test_helper'

class PublicationAttachmentTest < ActiveSupport::TestCase
  def publication_attachment
    @publication_attachment ||= PublicationAttachment.new
  end

  def test_valid
    assert publication_attachment.valid?
  end
end
