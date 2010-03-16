require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')
require 'active_support'

class Facebooker::CommentTest < Test::Unit::TestCase

  def setup
    @session = Facebooker::Session.create('apikey', 'secretkey')
    Facebooker::Session.current = @session
    @user = Facebooker::User.new(1234, @session)
    @other_user = Facebooker::User.new(4321, @session)
    ENV['FACEBOOK_CANVAS_PATH'] ='facebook_app_name'
    ENV['FACEBOOK_API_KEY'] = '1234567'
    ENV['FACEBOOK_SECRET_KEY'] = '7654321'

    @user.friends = [@other_user]
  end


  
  def test_add_comment
    @user = Facebooker::User.new(548871286, @session)
    expect_http_posts_with_responses(example_add_comment_response)
    #puts "Facebooker::Session.current = #{Facebooker::Session.current}"
    @comment = Facebooker::Comment.new({ :xid=>'test_xid',:text=>'that was realy hilarious!' }) 
    assert_equal('403917', @comment.save )
  end
  
  
  def test_add_comment_with_object_id
    @user = Facebooker::User.new(548871286, @session)
    expect_http_posts_with_responses(example_add_comment_response)
    #puts "Facebooker::Session.current = #{Facebooker::Session.current}"
    @comment = Facebooker::Comment.new({ :object_id=>'test_xid',:text=>'that was realy hilarious!' }) 
    assert_equal('403917', @comment.save )
  end
  
  def test_add_comment_with_object_id_to_stream
    @user = Facebooker::User.new(548871286, @session)
    expect_http_posts_with_responses(example_add_comment_response)
    #puts "Facebooker::Session.current = #{Facebooker::Session.current}"
    @comment = Facebooker::Comment.new({ :object_id=>'test_xid',:text=>'that was realy hilarious!',:publish_to_stream=>true,:title=>"story title", :url=>"http://www.somesite.com/some/story" }) 
    assert_equal('403917', @comment.save )
  end

  def test_add_comment_with_post_id
    @user = Facebooker::User.new(548871286, @session)
    expect_http_posts_with_responses(example_comment_on_response)
    #puts "Facebooker::Session.current = #{Facebooker::Session.current}"
    @comment = Facebooker::Comment.new({ :post_id=>'test_post_id',:comment=>'that was realy hilarious!' }) 
    assert_equal('703826862_78463536863', @comment.save )
  end


  def test_get_comments_by_xid
    expect_http_posts_with_responses(example_comments_xml)
    comments = Facebooker::Comment.find(:xid=>'pete_comments')
    assert_equal('Hola', comments[0].text)
    assert_equal(2, comments.size)
  end

  def test_remove_true
    expect_http_posts_with_responses(example_comments_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find_by_xid('pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, comment.remove
  end
  
  def test_remove_false
    expect_http_posts_with_responses(example_comments_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find_by_xid('pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false, comment.remove
  end


  def test_delete_true
    expect_http_posts_with_responses(example_comments_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find_by_xid('pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, Facebooker::Comment.delete({:xid=>'pete_comments',:comment_id=>comment.id})
  end
  
  def test_delete_false
    expect_http_posts_with_responses(example_comments_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find_by_xid('pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false, Facebooker::Comment.delete({:xid=>'pete_comments',:comment_id=>comment.id})
  end
  

  def test_get_comments_by_post_id
    expect_http_posts_with_responses(example_comments_by_post_xml)
    comments = Facebooker::Comment.find(:post_id=>'pete_comments')
    assert_equal('Hola', comments[0].text)
    assert_equal(2, comments.size)
  end
  
  
  def test_remove_by_post_true
    expect_http_posts_with_responses(example_comments_by_post_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find(:post_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, comment.remove
  end
  
  def test_remove_by_post_false
    expect_http_posts_with_responses(example_comments_by_post_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find(:post_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false, comment.remove
  end


  def test_delete_by_post_true
    expect_http_posts_with_responses(example_comments_by_post_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find(:post_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, Facebooker::Comment.delete({:post_id=>'pete_comments',:comment_id=>comment.id})
  end
  
  def test_delete_by_post_false
    expect_http_posts_with_responses(example_comments_by_post_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find(:post_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false, Facebooker::Comment.delete({:post_id=>'pete_comments',:comment_id=>comment.id})
  end

  
  
  def test_get_comments_by_object_id
    expect_http_posts_with_responses(example_comments_by_object_xml)
    comments = Facebooker::Comment.find(:object_id=>'pete_comments')
    assert_equal('Hola', comments[0].text)
    assert_equal(2, comments.size)
  end


  def test_remove_by_object_true
    expect_http_posts_with_responses(example_comments_by_object_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find(:object_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, comment.remove
  end
  
  def test_remove_by_object_false
    expect_http_posts_with_responses(example_comments_by_object_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find(:object_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false, comment.remove
  end

  def test_delete_by_object_true
    expect_http_posts_with_responses(example_comments_by_object_xml,example_remove_comment_true)
    comments = Facebooker::Comment.find(:object_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal true, Facebooker::Comment.delete({:comment_id=>comment.id})
  end
  
  def test_delete_by_object_false
    expect_http_posts_with_responses(example_comments_by_object_xml,example_remove_comment_false)
    comments = Facebooker::Comment.find(:object_id=>'pete_comments')
    comment = comments[0]
    #expect_http_posts_with_responses()
    assert_equal false,  Facebooker::Comment.delete({:comment_id=>comment.id})
  end
  


private


  def example_remove_comment_true
    "1"
  end
  
  def example_remove_comment_false
    "0"
  end

  def example_comments_xml
    <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <comments_get_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
        <comment>
          <xid>pete_comments</xid>
          <fromid>563683308</fromid>
          <time>1234227529</time>
          <text>Hola</text>
          <id>65020</id>
        </comment>
        <comment>
          <xid>pete_comments</xid>
          <fromid>563683308</fromid>
          <time>1234227542</time>
          <text>holla</text>
          <id>65021</id>
        </comment>
      </comments_get_response>
    XML
  end
  
  def example_comments_by_post_xml
    <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <stream_getComments_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
        <comment>
          <post_id>pete_comments</post_id>
          <fromid>563683308</fromid>
          <time>1234227529</time>
          <text>Hola</text>
          <id>65020</id>
        </comment>
        <comment>
          <post_id>pete_comments</post_id>
          <fromid>563683308</fromid>
          <time>1234227542</time>
          <text>holla</text>
          <id>65021</id>
        </comment>
      </comments_get_response>
    XML
  end
  
  def example_comments_by_object_xml
    <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <comments_get_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
        <comment>
          <object_id>pete_comments</object_id>
          <fromid>563683308</fromid>
          <time>1234227529</time>
          <text>Hola</text>
          <id>65020</id>
        </comment>
        <comment>
          <object_id>pete_comments</object_id>
          <fromid>563683308</fromid>
          <time>1234227542</time>
          <text>holla</text>
          <id>65021</id>
        </comment>
      </comments_get_response>
    XML
  end
  
  def example_add_comment_response
    <<-eoxml
<?xml version="1.0" encoding="UTF-8"?>
<comments_add_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">403917</comments_add_response>
    eoxml
  end
  
  def example_comment_on_response
    <<-eoxml
<?xml version="1.0" encoding="UTF-8"?>
<stream_addComment_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">703826862_78463536863</stream_addComment_response>
    eoxml
  end
  
end
