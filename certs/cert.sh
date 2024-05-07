openssl req -x509 \
   -config /home/certs/minikube_postgres_root.cnf \
   -nodes \
   -keyout /home/certs/minikube_postgres_root.key \
   -out /home/certs/minikube_postgres_root.crt

openssl req -new \
   -config /home/certs/server.cnf \
   -nodes \
   -keyout /home/certs/server.key \
   -out /home/certs/server.csr

openssl x509 -req \
   -in /home/certs/server.csr \
   -days 365 \
   -CA /home/certs/minikube_postgres_root.crt \
   -CAkey /home/certs/minikube_postgres_root.key \
   -CAcreateserial \
   -out /home/certs/server.crt \
   -extensions cert_ext \
   -extfile /home/certs/server.cnf

cp /home/certs/* /home/server-key/
chown root:root /home/server-key/server.key
chmod 0640 /home/server-key/server.key

ls -l