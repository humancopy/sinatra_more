require File.dirname(__FILE__) + '/support_lite'
load File.dirname(__FILE__) + '/markup_plugin/output_helpers.rb'
load File.dirname(__FILE__) + '/warden_plugin/warden_helpers.rb'

module SinatraMore
  module WardenPlugin
    # This is the basic password strategy for authentication
    def self.registered(app)
      require 'warden' unless defined?(Warden)
      load File.dirname(__FILE__) + '/warden_plugin/password_strategy.rb'
      raise "WardenPlugin::Error - Install warden with 'sudo gem install warden' to use plugin!" unless Warden && Warden::Manager
      app.use Warden::Manager do |manager|
        manager.default_strategies :password
        manager.failure_app = app
        manager.serialize_into_session { |user| user.nil? ? nil : user.id }
        manager.serialize_from_session { |id| id.nil? ? nil : PasswordStrategy.user_class.find(id) }
      end
      app.helpers SinatraMore::OutputHelpers
      app.helpers SinatraMore::WardenHelpers
      Warden::Manager.before_failure { |env,opts| env['REQUEST_METHOD'] = "POST" }
      Warden::Strategies.add(:password, PasswordStrategy)
      PasswordStrategy.user_class = User if defined?(User)
    end
  end
end
