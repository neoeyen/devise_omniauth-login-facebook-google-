class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,  # 메일 인증 confirmable 설정
         :omniauthable  # omniauth 내용 추가

  has_many :identities, dependent: :destroy  # 한계정당 복수의 Identity를 생성할 수도 있어 일단 보류

  # omniauth로 추가한 내용 http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  # 깃허브 내용과 병행해서 변경 - 깃허브쪽이 더 심플한 코드 - 각 SNS로 로그인 할때, 메일이 다르면 다른계정이여도 상관 없음

  # TEMP_EMAIL_PREFIX = 'change@me'
  # TEMP_EMAIL_REGEX = /\Achange@me/
  # validates_presence_of :name

  TEMP_EMAIL_PASSWORD_PREFIX = 'require_change_password'
  # TEMP_EMAIL_REGEX = /\Arequire_change_password_/
  # validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update  -- 이건 업데이트 할때 해당 텍스트가 없어야 한다는 말임


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      #email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      #email = auth.info.email if email_is_verified
      #user = User.where(:email => email).first if email

      # 이미 있는 이메일인지 확인한다. - 깃허브
      email = auth.info.email
      user = User.where(:email => email).first
      unless self.where(email: auth.info.email).exists?

        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            email: auth.info.email,
            # email: "#{auth.info.email}_#{TEMP_EMAIL_PASSWORD_PREFIX}",
            name: "#{auth.info.name||auth.extra.nickname}_#{TEMP_EMAIL_PASSWORD_PREFIX}",
            image: auth.info.image || "#{options[:secure_image_url] ? 'https' : 'http'}://graph.facebook.com/#{uid}/picture?type=normal",
            password: Devise.friendly_token[0,20]
          )
          user.skip_confirmation!
          user.save!
        end

      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def require_password_reset?
   # self.password == TEMP_PASSWORD_PREFIX  # true 이면 재설정 해야함 -- 재정의 해서 보안문제 해결 필요함
   # self.email && self.email !~ TEMP_EMAIL_REGEX
   self.name.include? TEMP_EMAIL_PASSWORD_PREFIX
  end

  # 아래 두개의 이메일 메소드는 왜 있는지? - 깃허브 소스
  # def email_required?
  #  false
  # end

  # def email_changed?
  #  false
  # end

end
