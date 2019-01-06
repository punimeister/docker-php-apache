#! /bin/sh
if [ "${ERROR_LOG}" = "1" ]; then
  sed -i s/\;error_log/error_log/ /usr/local/etc/php/php.ini
  sed -i s/\;log_errors/log_errors/ /usr/local/etc/php/php.ini
fi
if [ "${REMOTE_DEBUG}" = "1" ]; then
  sed -i s/\;xdebug\.remote/xdebug\.remote/ /usr/local/etc/php/php.ini
fi
