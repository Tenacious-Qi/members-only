require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @post = posts(:joepost)
  end

  test "should redirect /posts/new to sign_in page when not logged in" do
    get new_post_path
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  # protect against unlikely curl commands attempting posts without being logged in
  test "should redirect post create requests to sign_in page when not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "dummy text"} }
    end
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  test "should redirect destroy for wrong post" do
    sign_in members(:joe)
    post = posts(:zeuspost)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_path
  end

  test "should delete post if post belongs to current member" do
    sign_in members(:joe)
    post = posts(:joepost)
    assert_difference 'Post.count', -1 do
      delete post_path(post)
    end
  end
end
