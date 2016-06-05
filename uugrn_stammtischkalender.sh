#! /bin/sh
#
# Berechnet regelmaessige Termine und erzeugt 
# Raphael Eiselstein <rabe@uugrn.org>

SQL_STAMMTISCH="ORT_ID=12, TEXT='UnixStammtisch', EVENT_LINK='https://stammtisch.uugrn.org/', WIKI_UUGRN='UUGRN:Stammtisch', WIKI_RNW='UnixStammtisch'"
SQL_FIXME="ORT_ID=14, TEXT='FIXME', EVENT_LINK='https://fixme.uugrn.org/', WIKI_UUGRN='UUGRN:FIXME_Treffen', WIKI_RNW='FIXME'"

YEAR=${1:-$(date +%Y)}
test "${YEAR}" -gt 2000 -a "${YEAR}" -lt 2038 || YEAR="$(date +%Y)"

for MONTH in $(seq -w 01 12); do 
	for DAY in $(seq -w 01 31);  do 
		date "+%u|%d|%F" --date "${YEAR}-${MONTH}-${DAY}" 2>/dev/null
	done
done | 
while IFS='|' read DOW DOM DATE; do

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

  SQL="insert into KALENDER set ID=0"
  SQL2=""
  case ${NIM}-${DOW} in
    1-5) # 1. Freitag
      SQL2=", DATUM='${DATE} 19:00:00', ${SQL_FIXME}  "
      ;;
    3-1) # 3. Montag
      SQL2=", DATUM='${DATE} 19:00:00', ${SQL_STAMMTISCH} "
      ;;
    #*-2) # jeden Dienstag
    #  SQL2=", DATUM='${DATE} 20:00:00', ORT_ID=11, TEXT='RZL Treffen', EVENT_LINK='https://raumzeitlabor.de/'"
    # ;;
  esac

  if [ -n "${SQL2}" ]; then
    echo "${SQL}${SQL2};"
  fi
done 
