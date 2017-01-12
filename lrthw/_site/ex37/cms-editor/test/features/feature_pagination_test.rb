require 'test_helper'

# Test Publications actions
class FeaturePaginationTest < Capybara::Rails::TestCase
  def setup_as_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def setup_as_non_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('rg373')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_pagination_links_admin
    setup_as_admin

    # Go to content list page
    visit root_path

    assert page.has_content?('Existing content items'), 'Not on content list page'

    # Check that pagination is displayed
    assert page.has_content?('Displaying items 1 - 30'), 'Item count not displayed'
    assert page.has_css?('li.next a[rel=next]'), 'Next page link not displayed'
    assert page.has_css?('li.last a'), 'Last page link not displayed'

    # Go to next page
    assert click_link('Next')

    # Check that pagination is displayed
    assert page.has_content?('Displaying items 31 - 60'), 'Item count not displayed'
    assert page.has_css?('li.prev a[rel=prev]'), 'Prev page link not displayed'
    assert page.has_css?('li.first a'), 'First page link not displayed'
  end

  def test_pagination_links_non_admin
    setup_as_non_admin

    # Go to content list page
    visit root_path

    assert page.has_content?('Existing content items'), 'Not on content list page'

    # Check that pagination is displayed
    assert page.has_content?('Displaying items 1 - 30'), 'Item count not displayed'
    assert page.has_css?('li.next a[rel=next]'), 'Next page link not displayed'
    assert page.has_css?('li.last a'), 'Last page link not displayed'

    # Go to next page
    assert click_link('Next')

    # Check that pagination is displayed
    assert page.has_content?('Displaying items 31 - 60'), 'Item count not displayed'
    assert page.has_css?('li.prev a[rel=prev]'), 'Prev page link not displayed'
    assert page.has_css?('li.first a'), 'First page link not displayed'
  end
end
