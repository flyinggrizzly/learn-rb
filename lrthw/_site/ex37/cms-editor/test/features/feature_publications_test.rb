require 'test_helper'

# Test Publications actions
class FeaturePublicationsTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_should_create_publication
    visit new_publication_path

    assert page.has_content?('New publication'), 'Screen for creating new publication not rendered properly'

    assert fill_in('publication_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('publication_content_item_attributes_i_need', with: 'to create a publication'), "Couldn't set i_need field"
    assert fill_in('publication_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('publication_content_item_attributes_title', with: 'Brand new publication'), "Couldn't set title field"
    assert fill_in('publication_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"
    assert fill_in('publication_additional_info', with: 'Here is a PDF on stuff you can download and read about.'), "Couldn't set value for additional information"
    assert choose('publication_subtype_promotional_material'), 'Could not choose "Promotional material" subtype for publication'
    assert attach_file('publication[publication_attachments_attributes][0][attachment]', File.absolute_path('./test/fixtures/attachment-files/Psychology_UG_Brochure.pdf'))
    assert choose('publication_restricted_false'), 'Could not choose public option for attachments restriction for publication'

    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_publication
    visit delete_path
    assert page.has_content?('For test deletion publication'), 'Publication to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_publication_content_item).id
    publication_id = publications(:for_test_deletion_publication).id
    publication_attachment_id = publication_attachments(:for_test_deletion_publication_attachment).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Publication.find(publication_id)
    refute_nil PublicationAttachment.find(publication_attachment_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion publication'), 'Publication not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Publication.find(publication_id) }
    assert_raise(ActiveRecord::RecordNotFound) { PublicationAttachment.find(publication_attachment_id) }
  end

  def test_no_attached_file_should_be_invalid
    visit new_publication_path

    assert page.has_content?('New publication'), 'Screen for creating new publication not rendered properly'

    assert fill_in('publication_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('publication_content_item_attributes_i_need', with: 'to create a publication'), "Couldn't set i_need field"
    assert fill_in('publication_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('publication_content_item_attributes_title', with: 'Brand new publication'), "Couldn't set title field"
    assert fill_in('publication_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"
    assert choose('publication_subtype_promotional_material'), 'Could not choose "Promotional material" subtype for publication'
    assert choose('publication_restricted_false'), 'Could not choose public option for attachments restriction for publication'

    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal publications_path, page.current_path
    assert page.has_content?(I18n.t('activerecord.errors.models.publication.attributes.publication_attachments.blank'))
  end

  def test_attaching_jpg_invalid
    visit new_publication_path

    assert page.has_content?('New publication'), 'Screen for creating new publication not rendered properly'

    assert fill_in('publication_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('publication_content_item_attributes_i_need', with: 'to create a publication'), "Couldn't set i_need field"
    assert fill_in('publication_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('publication_content_item_attributes_title', with: 'Brand new publication'), "Couldn't set title field"
    assert fill_in('publication_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"
    assert choose('publication_subtype_promotional_material'), 'Could not choose "Promotional material" subtype for publication'
    assert choose('publication_restricted_false'), 'Could not choose public option for attachments restriction for publication'
    assert attach_file('publication[publication_attachments_attributes][0][attachment]', File.absolute_path('./test/fixtures/attachment-files/four-legged-snake.jpg'))

    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal publications_path, page.current_path

    # I18n.t() doesn't interpolate the %{allowed_types} from the lang file
    assert page.has_content?('The file must be a')
  end

  def test_add_files_in_order
    visit new_publication_path

    assert page.has_content?('New publication'), 'Screen for creating new publication not rendered properly'

    assert fill_in('publication_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('publication_content_item_attributes_i_need', with: 'to create a publication with lots of attachments'), "Couldn't set i_need field"
    assert fill_in('publication_content_item_attributes_so_that', with: 'I can test whether the files are in the correct order'), "Couldn't set so_that field"
    assert fill_in('publication_content_item_attributes_title', with: 'Many attachments'), "Couldn't set title field"
    assert fill_in('publication_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"
    assert choose('publication_subtype_promotional_material'), 'Could not choose "Promotional material" subtype for publication'
    assert choose('publication_restricted_false'), 'Could not choose public option for attachments restriction for publication'

    assert attach_file('publication[publication_attachments_attributes][0][attachment]', File.absolute_path('./test/fixtures/attachment-files/file1.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.new_save'))
    assert page.find_by_id('attachment-filename-0').text == 'file1.docx'
    # We have to wait because files uploaded within a second of each other were coming out in random order - since we sort by created_by
    sleep 1

    assert attach_file('publication[publication_attachments_attributes][1][attachment]', File.absolute_path('./test/fixtures/attachment-files/file2.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.draft_save'))
    assert page.find_by_id('attachment-filename-1').text == 'file2.docx'
    sleep 1

    assert attach_file('publication[publication_attachments_attributes][2][attachment]', File.absolute_path('./test/fixtures/attachment-files/file3.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.draft_save'))
    assert page.find_by_id('attachment-filename-2').text == 'file3.docx'
    sleep 1

    assert attach_file('publication[publication_attachments_attributes][3][attachment]', File.absolute_path('./test/fixtures/attachment-files/file4.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.draft_save'))
    assert page.find_by_id('attachment-filename-3').text == 'file4.docx'
    sleep 1

    assert attach_file('publication[publication_attachments_attributes][4][attachment]', File.absolute_path('./test/fixtures/attachment-files/file5.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.draft_save'))
    assert page.find_by_id('attachment-filename-4').text == 'file5.docx'
    sleep 1

    assert attach_file('publication[publication_attachments_attributes][5][attachment]', File.absolute_path('./test/fixtures/attachment-files/file6.docx'))
    assert click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.draft_save'))
    assert page.find_by_id('attachment-filename-5').text == 'file6.docx'
  end

  def test_status_does_not_change_on_validation_error
    publication = publications(:test_status_does_not_change_on_validation_error_publication)
    visit edit_publication_path(publication.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert fill_in('publication_contact_email', with: 'Blah blah blah'), "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
