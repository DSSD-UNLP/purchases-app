class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  validates :email, presence: true
  validates :password, presence: true
  validates_confirmation_of :password

  def employee?
    External::Employee.find(email).present?
  rescue Flexirest::HTTPNotFoundClientException
    false
  end
end
