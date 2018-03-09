#!/bin/bash


function parseHTML {
  if [ -z "$1" ]; then
    url="https://dribbble.com/shots"
    f_name="$(date +%Y%m%d\.%H)-popular"

  else
    url="https://dribbble.com/shots?sort=$1"
    f_name="$(date +%Y%m%d\.%H)-$1"
  fi

  for l in `lynx -source "${url}" | grep dribbble-link | cut -d\" -f4` ; do
    html=$(curl -s "https://dribbble.com${l}")
    title=$(echo "${html}" | grep "og:title" | cut -d\" -f4 | sed 's/\&amp\;/&/g')
    info=$(echo "${html}" | grep -A 1 "shot-desc" | tail -1 | cut -d\> -f2 | sed 's/...$//g' | sed 's/\&amp\;/&/g')
    author=$(echo "${html}" | grep "rel=\"contact\"" | head -1 | cut -d\" -f6)
    author_url=$(echo "${html}" | grep "rel=\"contact\"" | head -1 | cut -d\" -f8)
    date=$(echo "${html}" | grep "/shots?date=" | cut -d\" -f2 | cut -d\= -f2)
    img=$(echo "${html}" | grep "source srcset.*screen" | head -1 | cut -d\" -f2)
    if [ -z "$img" ]; then img=$(echo "${html}" | grep "the-shot" | head -1 | cut -d\" -f6) ; fi
    colors=$(echo "${html}" | grep "/colors/" | cut -d\" -f4 | tr '\n' ',' | sed 's/\.$//g')
    tags=$(echo "${html}" | grep "rel=\"tag\"" | cut -d\" -f4 | tr '\n' ',' | sed 's/.$//g')
    likes=$(echo "${html}" | grep -A 1 "likes-count" | tail -1 | sed 's/\ //g ; s/,//g')
    views=$(echo "${html}" | grep -A 1 "views-count" | tail -1 | sed 's/\ //g ; s/,//g')

    html=$(curl -s "https://dribbble.com${author_url}")
    email=$(echo "${html}" | grep "og:description" | cut -d\" -f4 | grep -Eo '[A-Za-z0-9_\-\.]+@[A-Za-z0-9_\-\.]+')

    echo "\"${title}\",\"${author}\",${author_url},${email},${date},${img},\"${colors}\",\"${tags}\",${likes},${views}" >> ${f_name}.csv
  done

  echo ${f_name}.csv >> listings.txt
}


cd $DRIBBBLE_ETC

parseHTML
parseHTML "recent"
parseHTML "debuts"
parseHTML "teams"

exit 0;
