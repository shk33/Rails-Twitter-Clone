class User < ActiveRecord::Base
  
  #Callbacks
  before_save   :downcase_email
  before_create :create_activation_digest

  # Regexs for validatiosn
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #Model validations
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  #Attr Accessors
  attr_accessor :remember_token, :activation_token, :reset_token

  # Returns the hash digest of the given string.
  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Undo remember user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #Activates the user account
  def activate
    update_attribute :activated,    true
    update_attribute :activated_at, Time.zone.now
  end

  #Sends an activation email for the user account
  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  #Create a reset digest and its token for password reset
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest,  User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  # #Sends an email for reset the user password
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest activation_token
    end

end
