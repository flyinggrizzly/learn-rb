require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  def setup
    @collection = collections(:maximum_length_collection)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Collection, @collection, 'Should be an Collection'
    assert Collection.method_defined?(:published_version), 'Collection should include CanHavePublishingMetadataHooks'
    assert defined?(@collection.last_published_version), 'Collection should have a last_published_version field'
  end

  def test_maximum_length_collection
    assert @collection.valid?, 'Collection should have been valid'
  end

  def test_too_many_labels_collection
    refute collections(:test_too_many_labels_collection).valid?
  end

  def test_invalid_no_label_collection
    refute collections(:test_invalid_no_label_collection).valid?
  end

  def test_unique_labels_collection
    # The validation (labels_must_be_unique in ContentItem) needs to test creating from new,
    # as Admins can't edit the labels on a Collection.

    col = Collection.new
    ci = ContentItem.new(
      as_a: 'Developer',
      i_need: 'a collection that tries to set labels that are already on another collection',
      so_that: 'I can test the validations against this',
      title: "I'm a copycat collection",
      summary: 'This is my collection',
      core_data: col,
      core_data_type: 'Collection'
    )
    ci.labels = [
      labels(:induction_label),
      labels(:undergraduate_label)
    ]
    col.content_item = ci

    refute col.valid?
  end
end
