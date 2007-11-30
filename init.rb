require 'facebooker/rails/controller'
require 'facebooker/rails/facebook_url_rewriting'
require 'facebooker/rails/facebook_session_handling'
require 'facebooker/rails/routing'
require 'facebooker/rails/'

module ::ActionController
  class Base
    def self.inherited_with_facebooker(subclass)
      inherited_without_facebooker(subclass)
      if subclass.to_s == "ApplicationController"
        subclass.send(:include,Facebooker::Rails::Controller) 
        subclass.helper Facebooker::Rails::Helpers
      end
    end
    class << self
      alias_method_chain :inherited, :facebooker
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, Facebooker::Rails::Routing::MapperExtensions
ActionController::TestCase.send :include, Facebooker::Rails::TestHelpers::Functional