rails aborted!
StandardError: An error has occurred, this and all later migrations canceled:

SQLite3::SQLException: duplicate column name: reset_password_token
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:11:in `block in up'
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:5:in `up'

Caused by:
ActiveRecord::StatementInvalid: SQLite3::SQLException: duplicate column name: reset_password_token
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:11:in `block in up'
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:5:in `up'

Caused by:
SQLite3::SQLException: duplicate column name: reset_password_token
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:11:in `block in up'
/mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/db/migrate/20230716224411_add_devise_to_users.rb:5:in `up'
Tasks: TOP => db:migrate
(See full trace by running task with --trace)