init:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add jetstack https://charts.jetstack.io
	helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
	helm repo update
	helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --set installCRDs=true
	helm upgrade --install metrics-server metrics-server/metrics-server

retain:
	kubectl patch -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}' pv $(pv)
