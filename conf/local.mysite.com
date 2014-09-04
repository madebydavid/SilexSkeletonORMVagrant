<VirtualHost *:80>
	ServerName local.mysite.com
	ServerAlias local.mysite.com

	ServerAdmin webmaster@localhost

	DocumentRoot /var/www/web
	<Directory /var/www/web>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/local.mysite.com-error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog ${APACHE_LOG_DIR}/local.mysite.com-access.log combined
</VirtualHost>
