#!/bin/bash

function parse_options {
  function usage() {
    echo -e >&2 "Usage: $0 dump DATABASE [options...]
\t-u USERNAME\t(default: root)
\t-p PASSWORD\t(default: root)
\t-h HOST\t\t(default: localhost:8086)
\t-s\t\t(use HTTPS)"
  }
  if [ "$#" -lt 2 ]; then
    usage; exit 1;
  fi

  username=root
  password=root
  host=localhost:8086
  https=0
  shift
  database=$1
  shift

  while getopts u:p:h:s opts
  do case "${opts}" in
    u) username="${OPTARG}";;
    p) password="${OPTARG}";;
    h) host="${OPTARG}";;
    s) https=1;;
    ?) usage; exit 1;;
    esac
  done
  if [ "${https}" -eq 1 ]; then
    scheme="https"
  else
    scheme="http"
  fi
}

function dump {
  parse_options $@

  curl -s -k -G "${scheme}://${host}/db/${database}/series?u=${username}&p=${password}&chunked=true" --data-urlencode "q=select * from /.*/" \
    | jq . -c -M
  exit
}

function restore {
  parse_options $@

  while read -r line
  do
    echo >&2 "Writing..."
    curl -X POST -d "[${line}]" "${scheme}://${host}/db/${database}/series?u=${username}&p=${password}"
  done
  exit
}

case "$1" in
  dump)     dump $@;;
  restore)  restore $@;;
  *)      echo >&2 "Usage: $0 [dump|restore] ..."
    exit 1;;
esac
