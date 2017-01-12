require 'test_helper'

# Test validations for Publication
class PublicationTest < ActiveSupport::TestCase
  def setup
    @publication = publications(:ug_psychology_brochure)
    @publication.publication_attachments[0].attachment = sample_file('Psychology_UG_Brochure.pdf')
    @publication.publication_attachments[1].attachment = sample_file('coming-to-university-as-a-care-leaver.pdf')
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Publication, @publication, 'Should be a Publication'
    assert Publication.method_defined?(:published_version), 'Publication should include CanHavePublishingMetadataHooks'
    assert defined?(@publication.last_published_version), 'Publication should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @publication.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @publication.content_item.published!
    @publication.save!
    assert_equal @publication.content_item.url_path,
                 JSON.parse(@publication.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_maximum_length_valid
    pub = publications(:maximum_length_publication)
    pub.publication_attachments[0].attachment = sample_file('Psychology_UG_Brochure.pdf')
    assert pub.valid?, 'Publication should have been valid'
  end

  def test_valid
    assert @publication.valid?, 'Publication should have been valid'
  end

  def test_attachment_values
    @publication.publication_attachments.each do |pa|
      refute pa.attachment.filename.blank?
      refute pa.attachment.url.blank?
      refute pa.attachment.size.blank?
      refute pa.attachment.file.to_file.mtime.blank?
    end
  end

  def test_invalid_without_attachment
    invalid_pub = publications(:invalid_attachment_publication)
    refute invalid_pub.valid?
  end

  def test_output_attributes_for_publications
    # We have to run save to trigger CarrierWave on ActiveRecord activity
    @publication.save
    output = @publication.output_attributes

    refute_nil output, 'No output for redis'
    refute_nil output[:attachments][0][:attachment_filename], 'File name is not in the output for redis'
    assert_equal 'Psychology_UG_Brochure.pdf', output[:attachments][0][:attachment_filename], 'File name in redis output does not match actual file name'

    refute_nil output[:attachments][0][:attachment_file_size], 'No file size in output for redis'
    assert output[:attachments][0][:attachment_file_size] > 0, 'File size is zero'

    refute_nil output[:attachments][0][:attachment_updated_at], 'No updated at time in output for redis'
    refute_equal output[:attachments][0][:attachment_updated_at], @publication.publication_attachments[0].created_at, 'updated_at not updated'
    assert_kind_of Time, output[:attachments][0][:attachment_updated_at]

    refute_nil output[:attachments][0][:attachment_location], 'No attachment location in output for redis'
    assert_equal @publication.publication_attachments[0].attachment.path, output[:attachments][0][:attachment_location], 'Path in output for redis does not match actual attachment path'

    assert output[:attachments][0][:attachment_updated_at] < output[:attachments][1][:attachment_updated_at]
  end

  def test_attachments_in_created_order
    assert @publication.publication_attachments[0].created_at < @publication.publication_attachments[1].created_at, "Oldest attachment isn't returning first"
  end

  # TODO: content type checking not working yet - see https://www.pivotaltracker.com/n/projects/1262572/stories/104431742
  # def test_ivalid_content_type
  #   invalid_content_type = publications(:invalid_content_type_publication)
  #   invalid_content_type.attachment = sample_file('four-legged-snake.jpg')
  #   refute invalid_content_type.valid?
  #
  #   invalid_content_type.attachment = sample_file('four-legged-snake-with-spoof-file-ext.pdf')
  #   refute invalid_content_type.valid?
  # end
end
