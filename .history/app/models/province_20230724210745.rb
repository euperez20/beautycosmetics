class Province < ApplicationRecord
    has_many :users
    has_many :orders
    

    def self.ransackable_attributes(auth_object = nil)
        super + %w[name other_attribute orders_id_eq]
      end

    def self.ransackable_associations(auth_object = nil)
        ["users"] # Agrega las asociaciones que deseas permitir como buscables
    end
end
