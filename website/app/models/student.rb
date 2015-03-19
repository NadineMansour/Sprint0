class Student < ActiveRecord::Base

	 EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	 validates :username,
  		:presence => true,
  		:uniqueness => {
    	:case_sensitive => false
    }

    	
 def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_h).first
      end
    end



def self.authenticate(username_or_email="", login_password="")
  if  EMAIL_REGEX.match(username_or_email)    
    user = User.find_by_email(username_or_email)
  else
    user = User.find_by_username(username_or_email)
  end
  if user && user.match_password(login_password)
    return user
  else
    return false
  end
end   



def match_password(login_password="")
  encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
