# Configuration for the Passwordless gem: https://github.com/mikker

Passwordless.default_from_address = "no-reply@convene.zinc.coop"
Passwordless.redirect_back_after_sign_in = true
Passwordless.success_redirect_path = ENV["APP_ROOT_URL"]
Passwordless.sign_out_redirect_path = ENV["APP_ROOT_URL"]
# Expiry time for magic link
Passwordless.timeout_at = lambda { 1.hour.from_now }
