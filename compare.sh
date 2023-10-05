#!/bin/bash
set -eux

a='yace-main'
b='yace'

./${a} --listen-address 127.0.0.1:5005 --config.file config-min.yml &
PID=$(ps aux | grep yace | grep -v grep | awk '{print $2}')
sleep 10
curl -s localhost:5005/metrics | sed 's/\}.*/}/' | tee a.out | wc -l
kill $PID

./${b} --listen-address 127.0.0.1:5005 --config.file config-min.yml &
PID=$(ps aux | grep yace | grep -v grep | awk '{print $2}')
sleep 10
curl -s localhost:5005/metrics | sed 's/\}.*/}/' | tee b.out | wc -l
kill $PID

diff a.out b.out

grep --only-matching '^aws_apigateway_\w*' a.out | sort | uniq -c | sort -n > a-apigw.out
grep --only-matching '^aws_apigateway_\w*' b.out | sort | uniq -c | sort -n > b-apigw.out

diff a-apigw.out b-apigw.out
wc -l a-apigw.out b-apigw.out
