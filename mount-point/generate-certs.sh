#! /bin/bash

useradd -u 999 postgres

openssl req -new \
   -config /home/mount-point/certs/minikube_postgres_root.cnf \
   -nodes \
   -keyout /home/server-key/minikube_postgres_root.key \
   -out /home/server-key/minikube_postgres_root.csr

openssl x509 -req \
  -in /home/server-key/minikube_postgres_root.csr \
  -days 3650 \
  -extfile /etc/ssl/openssl.cnf \
  -extensions v3_ca \
  -signkey /home/server-key/minikube_postgres_root.key \
  -out /home/server-key/minikube_postgres_root.crt

openssl req -new \
   -config /home/mount-point/certs/server.cnf \
   -nodes \
   -keyout /home/server-key/server.key \
   -out /home/server-key/server.csr

# chown root:root /home/server-key/server.key
chmod 0600 /home/server-key/server.key

openssl x509 -req \
   -in /home/server-key/server.csr \
   -days 365 \
   -CA /home/server-key/minikube_postgres_root.crt \
   -CAkey /home/server-key/minikube_postgres_root.key \
   -CAcreateserial \
   -out /home/server-key/server.crt \
   -extensions cert_ext \
   -extfile /home/mount-point/certs/server.cnf

cp /home/server-key/* /home/mount-point/certs/
chown postgres /home/server-key/*

cp /home/mount-point/postgres.sh /home/pg_hba