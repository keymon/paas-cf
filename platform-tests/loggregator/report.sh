#!/usr/bin/env sh
set -e

msg_count=0
for i in `seq 1 $NUM_APPS`; do
    c=$(cat output-$i.txt | grep -c 'msg')
    : $(( msg_count = $msg_count + $c ))
done;

drain_count=$(curl -k https://https-drain.$CF_SYSTEM_DOMAIN/count)

currenttime=$(date +%s)

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
       [{\"metric\":\"smoke_test.ss.loggregator.msg_count\",
        \"points\":[[${currenttime}, ${msg_count}]],
        \"type\":\"gauge\",
        \"host\":\"${CF_SYSTEM_DOMAIN}\",
        \"tags\":[\"drain_version:${DRAIN_VERSION}\"]}
      ]
  }" \
"https://app.datadoghq.com/api/v1/series?api_key=$DATADOG_API_KEY"

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
       [{\"metric\":\"smoke_test.ss.loggregator.drain_msg_count\",
        \"points\":[[${currenttime}, ${drain_count}]],
        \"type\":\"gauge\",
        \"host\":\"${CF_SYSTEM_DOMAIN}\",
        \"tags\":[\"drain_version:${DRAIN_VERSION}\"]}
      ]
  }" \
"https://app.datadoghq.com/api/v1/series?api_key=$DATADOG_API_KEY"

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
       [{\"metric\":\"smoke_test.ss.loggregator.delay\",
        \"points\":[[${currenttime}, ${DELAY_US}]],
        \"type\":\"gauge\",
        \"host\":\"${CF_SYSTEM_DOMAIN}\",
        \"tags\":[\"drain_version:${DRAIN_VERSION}\"]}
      ]
  }" \
"https://app.datadoghq.com/api/v1/series?api_key=$DATADOG_API_KEY"

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
       [{\"metric\":\"smoke_test.ss.loggregator.cycles\",
       \"points\":[[${currenttime}, $(expr $CYCLES \* $NUM_APPS)]],
        \"type\":\"gauge\",
        \"host\":\"${CF_SYSTEM_DOMAIN}\",
        \"tags\":[\"drain_version:${DRAIN_VERSION}\"]}
      ]
  }" \
"https://app.datadoghq.com/api/v1/series?api_key=$DATADOG_API_KEY"
