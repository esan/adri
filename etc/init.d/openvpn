#!/bin/sh -e

### BEGIN INIT INFO
# Provides:          vpn
# Required-Start:    $network $local_fs
# Required-Stop:     $network $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Openvpn VPN service
### END INIT INFO

# Original version by Robert Leslie
# <rob@mars.org>, edited by iwj and cs
# Modified for openvpn by Alberto Gonzalez Iniesta <agi@inittab.org>
# Modified for restarting / starting / stopping single tunnels by Richard Mueller <mueller@teamix.net>

. /lib/lsb/init-functions

test $DEBIAN_SCRIPT_DEBUG && set -v -x

DAEMON=/usr/sbin/openvpn
DESC="virtual private network daemon(s)"
CONFIG_DIR=/etc/openvpn
test -x $DAEMON || exit 0
test -d $CONFIG_DIR || exit 0

# Source defaults file; edit that file to configure this script.
AUTOSTART="all"
STATUSREFRESH=10
if test -e /etc/default/openvpn ; then
  . /etc/default/openvpn
fi

start_vpn () {
    if grep -q '^[	 ]*daemon' $CONFIG_DIR/$NAME.conf ; then
      # daemon already given in config file
      DAEMONARG=
    else
      # need to daemonize
      DAEMONARG="--daemon ovpn-$NAME"
    fi

    if grep -q '^[	 ]*status ' $CONFIG_DIR/$NAME.conf ; then
      # status file already given in config file
      STATUSARG=""
    elif test $STATUSREFRESH -eq 0 ; then
      # default status file disabled in /etc/default/openvpn
      STATUSARG=""
    else
      # prepare default status file
      STATUSARG="--status /var/run/openvpn.$NAME.status $STATUSREFRESH"
    fi

    # Handle backwards compatibility
    if test -z "$( grep '^[[:space:]]*script-security[[:space:]]' $CONFIG_DIR/$NAME.conf )" ; then
        script_security="--script-security 2"
    fi

    STATUS=0
    # Check to see if it's already started...
    if test -e /var/run/openvpn.$NAME.pid ; then
      log_failure_msg "Already running (PID file exists)"
    else
      $DAEMON $OPTARGS --writepid /var/run/openvpn.$NAME.pid \
      $DAEMONARG $STATUSARG --cd $CONFIG_DIR \
      --config $CONFIG_DIR/$NAME.conf $script_security < /dev/null || STATUS=1
    fi
    log_end_msg $STATUS
}
stop_vpn () {
  kill `cat $PIDFILE` || true
  rm -f $PIDFILE
  rm -f /var/run/openvpn.$NAME.status 2> /dev/null
  log_end_msg 0
}

case "$1" in
start)
  log_action_begin_msg "Starting $DESC"

  # autostart VPNs
  if test -z "$2" ; then
    # check if automatic startup is disabled by AUTOSTART=none
    if test "x$AUTOSTART" = "xnone" -o -z "$AUTOSTART" ; then
      log_warning_msg "  Autostart disabled, no VPN will be started."
      exit 0
    fi
    if test -z "$AUTOSTART" -o "x$AUTOSTART" = "xall" ; then
      # all VPNs shall be started automatically
      for CONFIG in `cd $CONFIG_DIR; ls *.conf 2> /dev/null`; do
        NAME=${CONFIG%%.conf}
        log_daemon_msg "  Autostarting VPN '$NAME'"
        start_vpn
      done
    else
      # start only specified VPNs
      for NAME in $AUTOSTART ; do
        if test -e $CONFIG_DIR/$NAME.conf ; then
          log_daemon_msg "  Autostarting VPN '$NAME'"
          start_vpn
        else
          log_failure_msg "  Autostarting VPN '$NAME': missing $CONFIG_DIR/$NAME.conf file !"
          STATUS=1
        fi
      done
    fi
  #start VPNs from command line
  else
    while shift ; do
      [ -z "$1" ] && break
      NAME=$1
      if test -e $CONFIG_DIR/$NAME.conf ; then
        log_daemon_msg "  Starting VPN '$NAME'"
        start_vpn
      else
        log_failure_msg "  Starting VPN '$NAME': missing $CONFIG_DIR/$NAME.conf file !"
       STATUS=1
      fi
    done
  fi
  exit ${STATUS:-0}
  ;;
stop)
  log_action_begin_msg "Stopping $DESC"
  if test -z "$2" ; then
    PIDFILE=
    for PIDFILE in `ls /var/run/openvpn.*.pid 2> /dev/null`; do
      NAME=`echo $PIDFILE | cut -c18-`
      NAME=${NAME%%.pid}
      log_daemon_msg "  Stopping VPN '$NAME'"
      stop_vpn
    done
    if test -z "$PIDFILE" ; then
      log_warning_msg "  No VPN is running."
    fi
  else
    while shift ; do
      [ -z "$1" ] && break
      if test -e /var/run/openvpn.$1.pid ; then
        log_daemon_msg "  Stopping VPN '$1'"
        PIDFILE=`ls /var/run/openvpn.$1.pid 2> /dev/null`
        NAME=`echo $PIDFILE | cut -c18-`
        NAME=${NAME%%.pid}
        stop_vpn
      else
        log_failure_msg "  Stopping VPN '$1': No such VPN is running."
      fi
    done
  fi
  ;;
# Only 'reload' running VPNs. New ones will only start with 'start' or 'restart'.
reload|force-reload)
  log_action_begin_msg "Reloading $DESC"
  PIDFILE=
  for PIDFILE in `ls /var/run/openvpn.*.pid 2> /dev/null`; do
    NAME=`echo $PIDFILE | cut -c18-`
    NAME=${NAME%%.pid}
# If openvpn if running under a different user than root we'll need to restart
    if egrep '^[[:blank:]]*user[[:blank:]]' $CONFIG_DIR/$NAME.conf > /dev/null 2>&1 ; then
      log_daemon_msg "  Stopping VPN '$NAME'"
      stop_vpn
      sleep 1
      log_daemon_msg "  Restarting VPN '$NAME'"
      start_vpn
    else
      log_daemon_msg "  Restarting VPN '$NAME'"
      kill -HUP `cat $PIDFILE` || true
      log_end_msg 0
    fi
  done
  if test -z "$PIDFILE" ; then
    log_warning_msg "  No VPN is running."
  fi
  ;;
# Only 'soft-restart' running VPNs. New ones will only start with 'start' or 'restart'.
soft-restart)
  log_action_begin_msg "Soft-restarting $DESC"
  PIDFILE=
  for PIDFILE in `ls /var/run/openvpn.*.pid 2> /dev/null`; do
    NAME=`echo $PIDFILE | cut -c18-`
    NAME=${NAME%%.pid}
    log_daemon_msg "  Soft-restarting VPN '$NAME'"
    kill -USR1 `cat $PIDFILE` || true
    log_end_msg 0
  done
  if test -z "$PIDFILE" ; then
    log_warning_msg "  No VPN is running."
  fi
  ;;
restart)
  shift
  $0 stop ${@}
  sleep 1
  $0 start ${@}
  ;;
cond-restart)
  log_action_begin_msg "Restarting $DESC"
  PIDFILE=
  for PIDFILE in `ls /var/run/openvpn.*.pid 2> /dev/null`; do
    NAME=`echo $PIDFILE | cut -c18-`
    NAME=${NAME%%.pid}
    log_daemon_msg "  Stopping VPN '$NAME'"
    stop_vpn
    sleep 1
    log_daemon_msg "  Restarting VPN '$NAME'"
    start_vpn
  done
  if test -z "$PIDFILE" ; then
    log_warning_msg "  No VPN is running."
  fi
  ;;
status)
  GLOBAL_STATUS=0
  if test -z "$2" ; then
    # We want status for all defined VPNs.
    # Returns success if all autostarted VPNs are defined and running
    if test "x$AUTOSTART" = "xnone" ; then
      # Consider it a failure if AUTOSTART=none
      log_warning_msg "No VPN autostarted"
      GLOBAL_STATUS=1
    else
      if ! test -z "$AUTOSTART" -o "x$AUTOSTART" = "xall" ; then
        # Consider it a failure if one of the autostarted VPN is not defined
        for VPN in $AUTOSTART ; do
          if ! test -f $CONFIG_DIR/$VPN.conf ; then
            log_warning_msg "VPN '$VPN' is in AUTOSTART but is not defined"
            GLOBAL_STATUS=1
          fi
        done
      fi
    fi
    for CONFIG in `cd $CONFIG_DIR; ls *.conf 2> /dev/null`; do
      NAME=${CONFIG%%.conf}
      # Is it an autostarted VPN ?
      if test -z "$AUTOSTART" -o "x$AUTOSTART" = "xall" ; then
        AUTOVPN=1
      else
        if test "x$AUTOSTART" = "xnone" ; then
          AUTOVPN=0
        else
          AUTOVPN=0
          for VPN in $AUTOSTART; do
            if test "x$VPN" = "x$NAME" ; then
              AUTOVPN=1
            fi
          done
        fi
      fi
      if test "x$AUTOVPN" = "x1" ; then
        # If it is autostarted, then it contributes to global status
        status_of_proc -p /var/run/openvpn.${NAME}.pid openvpn "VPN '${NAME}'" || GLOBAL_STATUS=1
      else
        status_of_proc -p /var/run/openvpn.${NAME}.pid openvpn "VPN '${NAME}' (non autostarted)" || true
      fi
    done
  else
    # We just want status for specified VPNs.
    # Returns success if all specified VPNs are defined and running
    while shift ; do
      [ -z "$1" ] && break
      NAME=$1
      if test -e $CONFIG_DIR/$NAME.conf ; then
        # Config exists
        status_of_proc -p /var/run/openvpn.${NAME}.pid openvpn "VPN '${NAME}'" || GLOBAL_STATUS=1
      else
        # Config does not exist
        log_warning_msg "VPN '$NAME': missing $CONFIG_DIR/$NAME.conf file !"
        GLOBAL_STATUS=1
      fi
    done
  fi
  exit $GLOBAL_STATUS
  ;;
*)
  echo "Usage: $0 {start|stop|reload|restart|force-reload|cond-restart|status}" >&2
  exit 1
  ;;
esac

exit 0

# vim:set ai sts=2 sw=2 tw=0:
