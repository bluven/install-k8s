#!/bin/bash
kubeadm join 10.22.46.11:6443 \
  --token 0cr8dp.hfbg37hecz7svbso \
  --discovery-token-ca-cert-hash sha256:407f921afbcc431d2d73af0541a68df475437b35a02db72da7906935ddf9c5ef
