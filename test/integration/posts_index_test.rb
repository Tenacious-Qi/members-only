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

  test "only signed in members can delete posts that belong to them" do
    sign_in(@member)
    get posts_path
    assert_select 'a.delete-Joe-post'
    sign_out(@member)
    sign_in(@other_member)
    get posts_path
    assert_select 'a.delete-Joe-post', { count: 0 }
    assert_select 'a.delete-Zeus-post', { count: 1 }
  end
end
