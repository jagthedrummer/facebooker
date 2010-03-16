require 'facebooker/model'
module Facebooker
  ##
  # A simple representation of a comment
  # Since Facebook has two different ways to deal with comments
  # (via stream.* and via comments.*) we have to be flexible.
  # Which attr_accessors come in to play will depend on the context
  # for the comment in question.
  class Comment
    include Model
    attr_accessor :xid, :object_id, :fromid, :time, :text, :id
    attr_accessor :title,:url,:publish_to_stream    
    attr_accessor :post_id,:comment  #these are for the stream.addComment variation
    
    #options shoudl be something like this
    #{:xid=>xid,
    #  :text=>text,
    #  :title=>title,
    #  :url=>url,
    #  :publish_to_stream=>publish_to_stream}
    def initialize(options)
      super(options)
      #@session = session
      #@options = options
    end
  
    def save()
      if(!xid.nil? or !object_id.nil?)
        comment_save()
      else
        stream_save()
      end
    end
  
    def stream_save()
      params = {:post_id=>post_id,:comment=>comment,:uid=>Session.current.user.id}
      Session.current.post('facebook.stream.addComment',params,false)
    end
  
    def comment_save()
      params = {:text=>text,:title=>title,:url=>url,:publish_to_stream=>publish_to_stream,:uid=>Session.current.user.id}
      if(!xid.nil?)
        params[:xid] = xid
      elsif
        params[:object_id] = object_id
      end  
      Session.current.post('facebook.comments.add',params,false)
    end
    
    def self.find(options)
      if !options[:xid].nil?
        return find_by_xid(options[:xid])
      elsif !options[:object_id].nil?
        return find_by_object_id(options[:object_id])
      elsif !options[:post_id].nil?
        return find_by_post_id(options[:post_id])
      end
      return []
    end
    
    def self.get(options)
      self.find(options)
    end
    
    
    
    #pulls the comment list for a given FB post 
    def self.find_by_post_id(post_id)
      @comments = Session.current.post('facebook.stream.getComments',{:post_id => post_id}) do |response|
        response.map do |hash|
          Comment.from_hash(hash)
        end
      end
    end
    
    #pulls the comment list for a given FB object 
    def self.find_by_object_id(object_id)
      @comments = Session.current.post('facebook.comments.get',{:object_id => object_id}) do |response|
        response.map do |hash|
          Comment.from_hash(hash)
        end
      end
    end
    
    #pulls the comment list for a given xid
    def self.find_by_xid(xid)
      @comments = Session.current.post('facebook.comments.get',{:xid => xid}) do |response|
        response.map do |hash|
          Comment.from_hash(hash)
        end
      end
    end
      
    def self.delete(params)
      if !params[:xid].nil? and params[:xid] != ''
        Session.current.post('facebook.comments.remove', {:xid=>params[:xid], :comment_id =>params[:comment_id]})
      elsif !params[:object_id].nil? and params[:object_id] != ''
        Session.current.post('facebook.comments.remove', {:object_id=>params[:object_id], :comment_id =>params[:comment_id]})
      else
        Session.current.post('facebook.stream.removeComment', {:comment_id =>params[:comment_id]})
      end
    end

    #remove a this comment
    def remove()
      if !xid.nil?
        Session.current.post('facebook.comments.remove', {:xid=>xid, :comment_id =>id})
      elsif !object_id.nil?
        Session.current.post('facebook.comments.remove', {:object_id=>object_id, :comment_id =>id})
      elsif !post_id.nil?
        Session.current.post('facebook.stream.removeComment', {:comment_id =>id})
      end
    end
  
  
  
  end
  
  
  
  
end
