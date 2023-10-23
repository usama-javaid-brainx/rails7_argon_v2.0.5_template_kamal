class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum app_platform: [:react, :android, :ios, :flutter]
  enum status: [:active, :inactive, :blocked, :on_hold]

  validates :email, format: { with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/, multiline: true }, presence: true, uniqueness: { case_sensitive: false }

  def confirmed?
    true
  end

  def send_confirmation_notification?
    false
  end
end
