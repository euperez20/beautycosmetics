class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province 
  has_many :cart_items
  has_many :orders
  
  # Add the name attribute
  attr_accessor :name

  def self.ransackable_attributes(auth_object = nil)
    %w[admin created_at email id remember_created_at reset_password_sent_at reset_password_token updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name address province_id]
  end

  def self.ransackable_attributes(auth_object = nil)
    super + ['email']
  end



end
