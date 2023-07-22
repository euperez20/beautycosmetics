class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Add the name attribute
  attr_accessor :name

  def self.ransackable_attributes(auth_object = nil)
    %w[admin created_at email id updated_at] # Asegúrate de incluir solo los atributos deseados
  end




  
end
