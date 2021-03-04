require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @member = members(:joe)
    @post = @member.posts.build(content: "Dummy text")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "member id should be present" do
    @post.member_id = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end
end
