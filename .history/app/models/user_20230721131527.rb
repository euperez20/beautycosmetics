class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Add the name attribute
  attr_accessor :name

  def self.ransackable_associations(auth_object = nil)
    [] # Deja el arreglo vacío o agrega aquí las asociaciones deseadas
  end



end
