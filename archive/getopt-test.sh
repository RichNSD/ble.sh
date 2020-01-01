#!/bin/bash

# # usage
#
# declare "${ble_getopt_locals[@]}"
# ble/getopt.init "$0" "$@"
#
# while ble/getopt.next; do
#   case "$OPTION" in
#   (-a|--hoge)
#     echo hoge ;;
#   esac
# done
#
# if ! ble/getopt.finalize; then
#   print-usage
#   return 1
# fi

source getopt.sh

function command1 {
  eval "$ble_getopt_prologue"
  ble/getopt.init "$0" "$@"

  while ble/getopt.next; do
    case "$OPTION" in
    (-b|--bytes)  ble/util/print bytes  ;;
    (-s|--spaces) ble/util/print spaces ;;
    (-w|--width)
      if ! ble/getopt.get-optarg; then
        ble/getopt.print-argument-message "missing an option argument for $OPTION"
        _opterror=1
        continue
      fi
      ble/util/print "width=$OPTARG" ;;
    (--char-width|--tab-width|--indent-type)
      if ! ble/getopt.get-optarg; then
        ble/getopt.print-argument-message "missing an option argument for $OPTION"
        _opterror=1
        continue
      fi
      ble/util/print "${OPTION#--} = $OPTARG" ;;
    (--continue)
      if ble/getopt.has-optarg; then
        ble/getopt.get-optarg
        ble/util/print "continue = $OPTARG"
      else
        ble/util/print "continue"
      fi ;;
    (-i|--indent)
      if ble/getopt.has-optarg; then
        ble/getopt.get-optarg
        ble/util/print "indent = $OPTARG"
      else
        ble/util/print "indent"
      fi ;;
    (--text-justify|--no-text-justify)
      ble/util/print "${OPTION#--}" ;;
    (-[^-]*|--?*)
      ble/getopt.print-argument-message "unknown option."
      _opterror=1 ;;
    (*)
      ble/getopt.print-argument-message "unknown argument."
      _opterror=1 ;;
    esac
  done

  if ! ble/getopt.finalize; then
    ble/util/print "usage: getopt-test.sh [options]" >&2
    builtin exit 1
  fi
}

command1 -b --bytes -w 1 --width 10 --width=123 \
         --char-width --continue=10 --continue \
         -i --indent --indent= \
         --text-justify --unknown argument

