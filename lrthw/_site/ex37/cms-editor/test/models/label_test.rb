require 'test_helper'

# Test Label model
class LabelTest < ActiveSupport::TestCase
  def test_valid
    assert labels(:maximum_length_label).valid?, 'Label should have been valid'
  end

  def test_unique_name
    label = labels(:research_label)
    new_label = Label.new(name: label.name)
    refute new_label.valid?, 'Label with identical name should not be valid'

    new_label = Label.new(name: label.name.downcase)
    refute new_label.valid?, 'Label with identical name except case should not be valid'
  end

  def test_label_association_to_content_items
    label = labels(:research_label)
    label.content_items << content_items(:marketing_team_content_item)
    label.save
    refute label.content_items.blank?, 'Research label has no content items'
    assert labels(:research_label).content_items.include? content_items(:marketing_team_content_item)
  end

  def test_max_number_of_labels
    ci = corporate_informations(:test_max_number_of_labels)
    ci.content_item.labels.push(labels(:maximum_length_label), labels(:research_label), labels(:induction_label),
                                labels(:undergraduate_label), labels(:'2016_label'), labels(:'2017_label'),
                                labels(:two_word_label), labels(:brexit_label), labels(:worldwide_label))
    ci.save
    refute ci.valid?, 'Content item with more that 8 labels should not be valid'
  end

  def test_labels_in_published_json
    ci = corporate_informations(:test_labels_in_json_corporate_information)
    ci.content_item.published!
    ci.save!
    pub_json = JSON.parse(ci.content_item.published_item_json)
    assert_includes pub_json['labels'], 'Two_words'
    assert_includes pub_json['labels'], 'Undergraduate'
    assert_includes pub_json['labels'], 'Induction'
  end
end
