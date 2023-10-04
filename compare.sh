#!/bin/bash
set -x

./yace &
PID=$(ps aux | grep yace | grep -v grep | awk '{print $2}')
sleep 30
curl -s localhost:5000/metrics | sed 's/\}.*/}/' | tee a.out | wc -l
kill $PID

./yace -enable-feature=aws-sdk-v2,max-dimensions-associator,list-metrics-callback &
PID=$(ps aux | grep yace | grep -v grep | awk '{print $2}')
sleep 30
curl -s localhost:5000/metrics | sed 's/\}.*/}/' | tee b.out | wc -l
kill $PID

diff a.out b.out