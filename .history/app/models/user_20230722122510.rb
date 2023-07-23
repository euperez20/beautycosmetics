class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province       
  
  # Add the name attribute
  attr_accessor :name

  def self.ransackable_attributes(auth_object = nil)
    %w[admin created_at email id remember_created_at reset_password_sent_at reset_password_token updated_at]
  end
  



end
