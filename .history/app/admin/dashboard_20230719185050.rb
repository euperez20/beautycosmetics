# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    content do
      para "Bienvenido al panel de administración de BeautyCosmetics."
    end

     # Add the login link
     div class: 'login-link' do
      span 'Admin Login DEv: '
      a 'Login', href: new_admin_user_session_path
    end





  end # content
end
