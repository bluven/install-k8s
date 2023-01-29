#!/bin/bash
kubeadm init \
  --kubernetes-version 1.22.5 \
  --apiserver-advertise-address=10.22.46.11 \
  --service-cidr=10.234.0.0/18 \
  --pod-network-cidr=10.234.64.0/18 \
  --image-repository registry.aliyuncs.com/google_containers
