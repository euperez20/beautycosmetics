
ActiveAdmin.register_page "CustomersWithOrdersReport" do
    menu priority: 1, label: "Customers with Orders Report"
  
    content title: "Customers with Orders" do
      table_for OrderItem.includes(order: [:user, :province]) do
        column "Customer", sortable: 'users.email' do |order_item|
          order_item.order&.user&.email || "N/A"
        end
        column "Products" do |order_item|
          order_item.product.name
        end
        column "Taxes", &:taxes
        column "Order Total", &:order_total
      end
    end
  end
  