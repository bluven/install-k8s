#!/bin/bash
kubeadm init \
  --kubernetes-version 1.22.5 \
  --apiserver-advertise-address=10.22.48.16 \
  --service-cidr=10.233.0.0/18,fd96:ee88:0:1::0/116 \
  --pod-network-cidr=10.233.64.0/18,fd96:ee88:2::0/48 \
  --image-repository registry.aliyuncs.com/google_containers
