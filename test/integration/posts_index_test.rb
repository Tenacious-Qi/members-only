require "test_helper"

class PostsIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @member = members(:joe)
    @other_member = members(:zeus)
    @post = posts(:joepost)
  end

  test "index shows posts after logging in" do
    sign_in(@member)
    get posts_path
    assert_template 'posts/index'
  end

  test "author name visible only to logged in members" do
    get posts_path
    assert_match "Author name visible to Members only.", response.body
    sign_in(@member)
    get posts_path
    assert_match "Post Author: ", response.body
    sign_out(@member)
    get posts_path
    assert_match "Author name visible to Members only.", response.body
  end

  test "only signed in members can delete posts" do
    get posts_path
    assert_select 'a', { text: 'delete', count: 0}
  end

  # practice using Capybara methods
  test "only signed in members can delete posts that belong to them" do
    # sign in as Joe (can't delete Zeus' posts)
    sign_in(@member)
    visit('posts#index')
    assert page.has_xpath?("//a[@data-test-id='Joe-post']")
    assert page.has_no_xpath?("//a[@data-test-id='Zeus-post']")

    sign_out(@member)

    # sign in as Zeus (can't delete Joe's posts)
    sign_in(@other_member)
    visit('posts#index')
    assert page.has_xpath?("//a[@data-test-id='Zeus-post']")
    assert page.has_no_xpath?("//a[@data-test-id='Joe-post']")
  end
end
