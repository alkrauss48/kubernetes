My Kubernetes Config
===

This repo houses my Digital Ocean managed kubernetes configuration for the following projects:
* [thecodeboss.dev](https://thecodeboss.dev)
  * Includes redirect from [thesocietea.org](https://thesocietea.org)
* [labs.thecodeboss.dev](https://labs.thecodeboss.dev)
  * Includes redirect from [labs.thesocietea.org](https://labs.thesocietea.org)
* [resume.thecodeboss.dev](https://resume.thecodeboss.dev)
* [growlerfriday.com](https://growlerfriday.com)
* [websockets.thecodeboss.dev](https://websockets.thecodeboss.dev)

## Getting Started
**Note**: This repo is configured to work with [Digital Ocean's managed
kubernetes](https://www.digitalocean.com/products/kubernetes/).
Other implementations may also work, but YMMV.

You will need `helm` installed. On MacOS, you can do this with:
```
brew install helm
```

Next, run:
```
make init # Adds and installs key helm repos

kubectl apply -f namespaces.yaml # Adds namespaces
kubectl apply -f production_issuer.yaml # Adds LetsEncrypt TLS cert issuer
kubectl apply -f volumes.yaml # Adds PersistentVolumeClaims and PersistentVolumes

# Optional - update volumes' reclaim policies to 'Retain'
make retain pv=$PV_NAME # Run this for each volume
```

## thecodeboss.dev

Services: 2 (app & db)
Includes: Deployments, Services, Ingresses, Secret, and Volumes

To Deploy:
```
cp thecodeboss/secrets.yaml.example thecodeboss/secrets.yaml
# Add in your secrets to thecodeboss/secrets.yaml

kubectl apply -f thecodeboss
```

## labs.thecodeboss.dev

Services: 2 (frontend & backend)
Includes: Deployments, Services, and Ingresses

To Deploy:
```
kubectl apply -f labs
```

## resume.thecodeboss.dev

Services: 2 (app & db)
Includes: Deployments, Services, Ingresses, Secrets, and Volumes

To Deploy:
```
cp resume-haus/secrets.yaml.example resume-haus/secrets.yaml
# Add in your secrets to resume-haus/secrets.yaml

kubectl apply -f resume-haus
```

## growlerfriday.com

Services: 1 (frontend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f growler-friday
```

## websockets.thecodeboss.dev

Services: 2 (frontend & backend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f websockets
```
