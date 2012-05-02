# encoding: utf-8

namespace :dev do
  desc 'Supprime la base de donnée de dév et refais les migrations, et les seeds'
  task :reset do
    sh %{rm -f db/*.sqlite3 db/schema.rb}
    sh %{rake db:migrate db:seed}
  end
end
