#!/bin/bash

#-- change to tmp file directory
cd $ELLO_ETC
ts=$(date +%s)

#-- loop thru posts
for l in `curl -s "https://ello.co" | grep "/post/" | cut -d\" -f2` ; do 
  #-- store each match
  html=$(curl -s "${l}")
  
  #-- pull out the details per post (title/author/image/tags/like/views)
  author=$(echo "${html}" | grep "Post by" | cut -d\" -f3 | cut -d\  -f1 | sed 's/^.//g')
  author_url=$(echo "${html}" | grep "Post by" | cut -d\" -f2)
  title=$(echo "${html}" | grep "og:description" | cut -d\" -f4 | sed 's/\&amp\;/&/g ; s/\&quot\;/\"/g ; s/\&\#39\;/'\''/g')
  img=$(echo "${html}" | grep "og:image" | cut -d\" -f4 | tr '\n' ',' | sed 's/.$//g')
  hashtags=$( echo "${html}" | tr '<' '\n' | grep "hashtagClick" | cut -d\> -f2 | tr '\n' ',' | sed 's/.$//g')
  likes=$(echo "${html}" | grep " Loves" | cut -d\> -f2 | cut -d\< -f1 | cut -d\  -f1)
  views=$(echo "${html}" | grep " Views" | cut -d\> -f2 | cut -d\< -f1 | cut -d\  -f1)

  #-- write to tmp csv
  echo "\"${title}\",\"${author}\",${author_url},\"${img}\",\"${hashtags}\",${likes},${views}" >> ello-${ts}.csv
done

#-- append to listings file
echo ello-${ts}.csv >> listings.txt

exit 0;
