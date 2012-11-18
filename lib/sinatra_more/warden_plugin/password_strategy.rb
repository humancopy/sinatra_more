module SinatraMore
	module WardenPlugin
		class PasswordStrategy < Warden::Strategies::Base
		  cattr_accessor :user_class

		  def valid?
		    username || password
		  end

		  def authenticate!
		    raise "Please either define a user class or set SinatraMore::WardenPlugin::PasswordStrategy.user_class" unless user_class
		    u = user_class.authenticate(username, password)
		    u.nil? ? fail!("Could not log in") : success!(u)
		  end

		  def username
		    params['username'] || params['nickname'] || params['login'] || params['email']
		  end

		  def password
		    params['password'] || params['pass']
		  end
		end
	end
end
