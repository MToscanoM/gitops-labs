#!/bin/bash

# Instalar k3s en el master
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Capturar el token del master
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# Capturar la IP del master
IP=$(hostname -I | awk '{print $1}')

# Crear el directorio /vagrant si no existe
mkdir -p /vagrant

# Guardar el token y la IP en el directorio compartido de Vagrant
echo "$TOKEN" > /vagrant/master_token
echo "$IP" > /vagrant/master_ip