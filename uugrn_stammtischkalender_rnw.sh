#! /bin/sh
#
# Berechnet regelmaessige Termine und erzeugt Wiki-Code
# Raphael Eiselstein <rabe@uugrn.org>


YEAR=${1:-$(date +%Y)}
test "${YEAR}" -gt 2000 -a "${YEAR}" -lt 2038 || YEAR="$(date +%Y)"

for MONTH in $(seq -w 01 12); do 
	for DAY in $(seq -w 01 31);  do 
		# will only print valid dates
		date "+%u|%d|%F|%m|%Y" --date "${YEAR}-${MONTH}-${DAY}" 2>/dev/null
	done
done | 
while IFS='|' read DOW DOM DATE MONTH YEAR; do
  WIKI=""
  # DOM: DAY-of-MONTH
  # DOW: DAY-of-WEEK
  # NIM: nth-in-MONTH
  case ${DOM} in
    01|02|03|04|05|06|07) NIM=1 ;;
    08|09|10|11|12|13|14) NIM=2 ;;
    15|16|17|18|19|20|21) NIM=3 ;;
    22|23|24|25|26|27|28) NIM=4 ;;
    29|30|31) NIM=5 ;;
    *) NIM="0" ;;
  esac

  case ${NIM}-${DOW} in
    1-5) # 1. Freitag
      WIKI="* '''${DOM}.${MONTH}.''' &ndash; [[FIXME]] im [[Dezernat16]] in [[Heidelberg]]"
      ;;
    3-1) # 3. Montag
      WIKI="* '''${DOM}.${MONTH}.''' &ndash; [[UnixStammtisch]] im [[METROPOLIS Heidelberg]]"
      ;;
    #*-2) # jeden Dienstag
    #  WIKI=* '''${DOM}.${MONTH}.''' &ndash; [[Veranstaltung jeden Dienstag]] in [[Location]]"
    # ;;
  esac
  if [ -n "${WIKI}" ]; then
     echo "${WIKI} <!-- ${DATE} -->"
  fi
done 
