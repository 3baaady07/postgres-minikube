#! /bin/bash

useradd -u 999 postgres

# Generate root Certificate Signing Request
openssl req -new \
   -config /home/mount-point/certs/minikube_postgres_root.cnf \
   -nodes \
   -keyout /home/server-key/minikube_postgres_root.key \
   -out /home/server-key/minikube_postgres_root.csr

# Sign the root Certificate Signing Request and generate a root certificate
openssl x509 -req \
  -in /home/server-key/minikube_postgres_root.csr \
  -days 3650 \
  -extfile /etc/ssl/openssl.cnf \
  -extensions v3_ca \
  -signkey /home/server-key/minikube_postgres_root.key \
  -out /home/server-key/minikube_postgres_root.crt

# Generate a user Certificate Signing Request
openssl req -new \
   -config /home/mount-point/certs/server.cnf \
   -nodes \
   -keyout /home/server-key/server.key \
   -out /home/server-key/server.csr

# Set permissions on private key
chmod 0600 /home/server-key/server.key

# Sign the user Certificate Signing Request and generate a user certificate
openssl x509 -req \
   -in /home/server-key/server.csr \
   -days 365 \
   -CA /home/server-key/minikube_postgres_root.crt \
   -CAkey /home/server-key/minikube_postgres_root.key \
   -CAcreateserial \
   -out /home/server-key/server.crt \
   -extensions cert_ext \
   -extfile /home/mount-point/certs/server.cnf

cp /home/server-key/minikube_postgres_root.crt /home/mount-point/certs/
chown postgres:postgres /home/server-key/*