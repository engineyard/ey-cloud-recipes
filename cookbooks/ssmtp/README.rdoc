= Enable the ssmtp recipe

This recipe deletes the content of /etc/ssmtp and symlinks /etc/ssmtp to /data/ssmtp so that mail server configs are preserved when instances are terminated.

1. Ensure ssmtp recipes in cookbooks/main/recipes/default.rb are not commented out: include_recipe "ssmtp"
2. Upload the recipe to the correct environment:
  ey recipes upload -e production
  ey recipes apply -e production
3. Redeploy the app.

= Create a ssmtp config file.

1. SSH into the site:
  ey ssh
2. Edit the ssmtp.conf file (settings are for SendGrid, other providers are similar):
  cd /data/ssmtp
  sudo nano ssmtp.conf

  root=postmaster
  mailhub=smtp.sendgrid.com:587
  rewriteDomain=[your domain]
  FromLineOverride=YES
  UseSTARTTLS=YES
  AuthUser=[your username]
  AuthPass=[your password]
  AuthMethod=LOGIN


= Modify Rails app to use sendmail

1. Add the following to config/production.rb or replace any existing config line:
  config.action_mailer.delivery_method = :sendmail
2. Push and deploy
