ActiveAdmin.register Order do
 
  
  permit_params :user_id, :total_amount, :
  NoMethodError in Admin::Orders#index
  
  Showing /home/eunice/.rbenv/versions/3.1.2/lib/ruby/gems/3.1.0/gems/activeadmin-3.0.0/app/views/active_admin/resource/index.html.arb where line #3 raised:
  
  undefined method `total_amount_eq' for Ransack::Search<class: Order, base: Grouping <combinator: and>>:Ransack::Search
  
  Extracted source (around line #114):
  
  112
  113
  114
  115
  116
  117
                
  
    
  
          end
        else
          super
        end
      end
  
  
  :status, :gst, :pst, :hst, :total_amount_with_taxes, :status, :name, :province_id, :address, :email

  index do
    selectable_column
    id_column
    column :user    
    column :total_amount
    column :total_amount_with_taxes
    column :status
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :total_amount
      f.input :status, as: :select, collection: Order.statuses.keys
      f.input :gst
      f.input :pst
      f.input :hst
      
    end
    f.actions
  end
end
