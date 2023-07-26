class Province < ApplicationRecord
    has_many :users
    has_many :orders
    

    def self.ransackable_attributes(auth_object = nil)
        super + %w[name other_attribute orders_id_eq]
      end

    def self.ransackable_associations(auth_object = nil)
        ["users"] # Agrega las asociaciones que deseas permitir como buscables
    end

    def hst_applicable
        # Aquí puedes definir la lógica para determinar si el HST aplica en esta provincia
        # Por ejemplo, podrías revisar si el hst_rate es mayor a cero para determinar si aplica HST
        hst_rate > 0
      end
end
