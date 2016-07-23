# RegisterSystem
A register system between professors and graduate students used in NCTUEE.

# Install
## Bundle install
```sh
bin/rake bundle install
```

## Configurate ENV
Setting the rails environments like `config/rails_env_template` and exec below command.
```sh
cp config/rails_env_template config/rails_env
source config/rails_env
```

## Configurate database and migrate
Setting the `config/database.yml` like `config/database_template.yml`.
Rake `seeds.rb` when you first time migrate database.
```sh
cp config/database_template.yml config/database.yml
cp db/seeds_default.rb db/seeds.rb
RAILS_ENV=production bin/rake db:create db:migrate db:seed
```

# Run server
```sh
bin/rails s -e production
```