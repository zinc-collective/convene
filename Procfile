web: bin/puma -C config/puma.rb
worker: bin/sidekiq -q default -q mailers
release:  bin/rake db:prepare && bin/rake release:after_build
assets: bin/webpack-dev-server
js: yarn build --watch
css: yarn build:css --watch
mail_server: yarn exec maildev
