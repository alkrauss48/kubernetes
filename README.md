My Kubernetes Config
===

This repo houses my Digital Ocean managed kubernetes configuration for the following projects:
* [thecodeboss.dev](https://thecodeboss.dev)
  * Includes redirect from [thecodeboss.dev/resume](https://thecodeboss.dev/resume)
  * Includes redirect from [thesocietea.org](https://thesocietea.org)
* [labs.thecodeboss.dev](https://labs.thecodeboss.dev)
  * Includes redirect from [labs.thesocietea.org](https://labs.thesocietea.org)
* [resumeha.us](https://resumeha.us)
  * Includes redirect from [resume.thesocietea.org](https://resume.thesocietea.org)
* [cyruskrauss.com](https://cyruskrauss.com)
* [api.cyruskrauss.com](https://api.cyruskrauss.com)
* [growlerfriday.com](https://growlerfriday.com)
* [mothercodesbest.dev](https://mothercodesbest.dev)
* [websockets.thecodeboss.dev](https://websockets.thecodeboss.dev)
* Carnegie Chart - Coming Soon

#### Note

This repo does **not** include my continuous deployment configuration. That is
housed in https://github.com/alkrauss48/fleet-infra, which uses the flux GitOps
tool to scan images for updates based on semver tags, and deploy those updated
images.

The deployment manifests in this repo will all refer to `latest`, while the
actual live deployments will refer to specific image tags specified in the
fleet-infra repo.

---

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

For rolling deployments:
```
kubectl rollout restart deployment/<deployment> -n <namespace>
```

## [thecodeboss.dev](https://thecodeboss.dev)

Services: 3 (frontend, wordpress, & db)
Includes: Deployments, Services, Ingresses, Secret, and Volumes

To Deploy:
```
cp thecodeboss/secrets.yaml.example thecodeboss/secrets.yaml
# Add in your secrets to thecodeboss/secrets.yaml

kubectl apply -f thecodeboss
```

## [labs.thecodeboss.dev](https://labs.thecodeboss.dev)

Services: 2 (frontend & backend)
Includes: Deployments, Services, and Ingresses

To Deploy:
```
kubectl apply -f labs
```

## [resumeha.us](https://resumeha.us)

Services: 2 (app & db)
Includes: Deployments, Services, Ingresses, Secrets, and Volumes

To Deploy:
```
cp resume-haus/secrets.yaml.example resume-haus/secrets.yaml
# Add in your secrets to resume-haus/secrets.yaml

kubectl apply -f resume-haus
```

## [cyruskrauss.com](https://cyruskrauss.com)

Services: 1 (frontend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f cyrus-lyrics-web
```

## [api.cyruskrauss.com](https://api.cyruskrauss.com)

Services: 1 (app)
Includes: Deployment, Service, Ingress, and Secrets

To Deploy:
```
kubectl apply -f cyrus-lyrics-api
```

## [growlerfriday.com](https://growlerfriday.com)

Services: 1 (frontend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f growler-friday
```

## [mothercodesbest.dev](https://mothercodesbest.dev)

Services: 1 (frontend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f mothercodesbest
```

## [websockets.thecodeboss.dev](https://websockets.thecodeboss.dev)

Services: 2 (frontend & backend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f websockets
```
