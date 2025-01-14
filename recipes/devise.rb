gem 'devise'

inject_into_file 'config/environments/development.rb', "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }\n", :after => "Application.configure do"
inject_into_file 'config/environments/test.rb',        "\nconfig.action_mailer.default_url_options = { :host => 'localhost:7000' }\n", :after => "Application.configure do"
inject_into_file 'config/environments/production.rb',  "\nconfig.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n", :after => "Application.configure do"

inject_into_file 'config/routes.rb', "\nroot :to => 'home#index'\n", :after => "Testapp::Application.routes.draw do"

after_bundler do
  generate 'devise:install'

  if recipes.include? 'mongo_mapper'
    gem 'mm-devise'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
    generate 'mongo_mapper:devise User'
  elsif recipes.include? 'mongoid'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
  end      

end

after_everything do
  generate "devise User"
  generate "devise:views"
end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: mbleigh

category: authentication
exclusive: authentication