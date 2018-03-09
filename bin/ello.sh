#!/bin/bash

cd $ELLO_ETC
ts=$(date +%s)

for l in `curl -s "https://ello.co" | grep "/post/" | cut -d\" -f2` ; do 
  html=$(curl -s "${l}")
  author=$(echo "${html}" | grep "Post by" | cut -d\" -f3 | cut -d\  -f1 | sed 's/^.//g')
  author_url=$(echo "${html}" | grep "Post by" | cut -d\" -f2)
  title=$(echo "${html}" | grep "og:description" | cut -d\" -f4 | sed 's/\&amp\;/&/g ; s/\&quot\;/\"/g ; s/\&\#39\;/'\''/g')
  img=$(echo "${html}" | grep "og:image" | cut -d\" -f4 | tr '\n' ',' | sed 's/.$//g')
  hashtags=$( echo "${html}" | tr '<' '\n' | grep "hashtagClick" | cut -d\> -f2 | tr '\n' ',' | sed 's/.$//g')
  likes=$(echo "${html}" | grep " Loves" | cut -d\> -f2 | cut -d\< -f1 | cut -d\  -f1)
  views=$(echo "${html}" | grep " Views" | cut -d\> -f2 | cut -d\< -f1 | cut -d\  -f1)

  echo "\"${title}\",\"${author}\",${author_url},\"${img}\",\"${hashtags}\",${likes},${views}" >> ello-${ts}.csv
done

exit 0;
