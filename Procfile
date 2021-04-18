# The Project-level procfile is used in development when running all the things
# at once.
# Individual modules may have their own Procfile for running independently on
# Heroku.
web: cd convene-web/ && bin/run
assets: cd convene-web/ && bin/webpack-dev-server
mail_server: yarn exec maildev
