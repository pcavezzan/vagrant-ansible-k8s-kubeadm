#!/bin/bash

set -euo pipefail

apt-get update 
apt-get install -y haproxy

cat >/etc/haproxy/haproxy.cfg <<EOF

global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin
	stats timeout 2m
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	tcp
	option	tcplog
	option	dontlognull
	timeout connect 10s
	timeout client  10m
	timeout server  10m
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http

#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
frontend k8s
	bind 192.168.200.40:6443
	default_backend api-server

frontend  nodes
  bind 192.168.200.40:80
  default_backend http-workers

#---------------------------------------------------------------------
# round robin balancing between the various backends
#---------------------------------------------------------------------
backend api-server
  balance roundrobin
  mode tcp
  server  api-server-1 192.168.200.10:6443  check inter 1000
  # server  api-server-2 192.168.200.11:6443  check inter 1000
  # server  api-server-3 192.168.200.12:6443  check inter 1000

backend http-workers
  balance roundrobin
  mode tcp
  server  node-1 192.168.200.20:80 check
  server  node-2 192.168.200.21:80 check
  server  node-3 192.168.200.22:80 check

EOF

systemctl restart haproxy
