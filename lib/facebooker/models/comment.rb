require 'facebooker/model'
module Facebooker
  ##
  # A simple representation of a comment
  class Comment
    include Model
    attr_accessor :xid, :fromid, :time, :text, :id
    
    #options shoudl be something like this
    #{:xid=>xid,
    #  :text=>text,
    #  :title=>title,
    #  :url=>url,
    #  :publish_to_stream=>publish_to_stream}
    def initialize(options)
      super(options)
      #@session = session
      @options = options
    end
  
    def save()
       Session.current.post('facebook.comments.add',@options,false)
    end
    
    #pulls the comment list for a given xid
    def self.get_by_xid(xid)
      @comments = Session.current.post('facebook.comments.get',{:xid => xid}) do |response|
        response.map do |hash|
          Comment.from_hash(hash)
        end
      end
    end
      
    #remove a this comment
    def remove()
      Session.current.post('facebook.comments.remove', {:xid=>xid, :comment_id =>id})
    end
  
  
  
  end
  
  
  
  
end