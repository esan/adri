#! /bin/sh
### BEGIN INIT INFO
# Provides:          binfmt-support
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Support for extra binary formats
# Description:       Enable support for extra binary formats using the Linux
#                    kernel's binfmt_misc facility.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=binfmt-support
DESC="additional executable binary formats"

test -x /usr/sbin/update-binfmts || exit 0

. /lib/lsb/init-functions
. /etc/default/rcS

set -e
CODE=0

case "$1" in
  start)
    log_daemon_msg "Enabling $DESC" "$NAME"
    update-binfmts --enable || CODE=$?
    log_end_msg $CODE
    exit $CODE
    ;;

  stop)
    log_daemon_msg "Disabling $DESC" "$NAME"
    update-binfmts --disable || CODE=$?
    log_end_msg $CODE
    exit $CODE
    ;;

  restart|force-reload)
    $0 stop
    $0 start
    ;;

  *)
    N=/etc/init.d/$NAME
    echo "Usage: $N {start|stop|restart|force-reload}" >&2
    exit 1
    ;;
esac

exit 0
