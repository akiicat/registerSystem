# RegisterSystem
A register system between professors and graduate students used in NCTUEE.

# Install
## Bundle install
```sh
bin/rake bundle install
```

## Configurate ENV
Setting the rails environments in `config/rails_env_template` and source it.
```sh
cp config/rails_env_template config/rails_env
source config/rails_env
```

## Migrate
After setting environments, rake `seeds.rb` when you first time migrate database.
```sh
cp db/seeds_default.rb db/seeds.rb
RAILS_ENV=production bin/rake db:create db:migrate db:seed
```

# Run server
```sh
bin/rails s -e production
```
