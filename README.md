My Kubernetes Config
===

This repo houses my Digital Ocean managed kubernetes configuration for the following projects:
* [thecodeboss.dev](https://thecodeboss.dev)
  * Includes redirect from [thesocietea.org](https://thesocietea.org)
* [simpleslides.dev](https://simpleslides.dev)
* [labs.thecodeboss.dev](https://labs.thecodeboss.dev)
  * Includes redirect from [labs.thesocietea.org](https://labs.thesocietea.org)
* [cyruskrauss.com](https://cyruskrauss.com)
* [api.cyruskrauss.com](https://api.cyruskrauss.com)
* [lucaskrauss.dev](https://lucaskrauss.dev)
* [growlerfriday.com](https://growlerfriday.com)
* [mothercodesbest.dev](https://mothercodesbest.dev)
* [nicu.mothercodesbest.dev](https://nicu.mothercodesbest.dev/)
* [websockets.thecodeboss.dev](https://websockets.thecodeboss.dev)
* [ask.thekrausshaus.com](https://ask.thekrausshaus.com)

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

Services: 1 (frontend)
Includes: Deployment, Service, Ingresses

To Deploy:
```
kubectl apply -f thecodeboss
```

## [simpleslides.dev](https://simpleslides.dev)

Services: 3 (app, db, redis)
Includes: Deployments, Services, Ingresses, Secrets, and Volume

To Deploy:
```
cp simple-slides/secrets.yaml.example simple-slides/secrets.yaml
# Add in your secrets to simple-slides/secrets.yaml

kubectl apply -f simple-slides
```


## [labs.thecodeboss.dev](https://labs.thecodeboss.dev)

Services: 2 (frontend & backend)
Includes: Deployments, Services, and Ingresses

To Deploy:
```
kubectl apply -f labs
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

## [lucaskrauss.dev](https://lucaskrauss.dev)

Services: 1 (frontend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f lucas-hints-web
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

## [nicu.mothercodesbest.dev](https://nicu.mothercodesbest.dev)

Services: 1 (app)
Includes: Deployment, Service, Ingress

To Deploy:
```
kubectl apply -f nicu-calculations
```

## [ask.thekrausshaus.com](https://ask.thekrausshaus.com)

The API behind the bar on [thekrausshaus.com](https://thekrausshaus.com). Two
bartenders answer questions over Server-Sent Events, grounded in a corpus
retrieved from Postgres.

Services: 3 (app, db, tei-embed)
Includes: Deployments, Services, Ingress, ConfigMap, Secrets, and Volumes

To Deploy:
```
cp ask-eddie/secrets.yaml.example ask-eddie/secrets.yaml
# Add in your secrets to ask-eddie/secrets.yaml

kubectl apply -f ask-eddie
```

#### Notes

**`db` is pgvector, not stock Postgres.** `book_chunks.embedding` is a
`vector(1024)` column; the application's own migration creates the extension.
The claim mounts at `/var/lib/postgresql` rather than `.../data` because
Postgres 18 moved `PGDATA` one level down.

**`tei-embed` is not optional.** Every question is embedded at query time by
the same model the corpus was embedded with, so retrieval stops working
without it, rather than degrading. First boot downloads ~2.3Gi of weights onto
the `tei-models` claim, which takes several minutes; the startup probe allows
fifteen. TEI publishes `linux/amd64` only.

**Reranking is off.** A second TEI instance needs another ~3Gi resident, which
the current node pool does not have. `BOOKS_RERANK_ENABLED` and
`HOUSE_RERANK_ENABLED` are `"false"` in the ConfigMap and retrieval falls back
to the fused RRF order. Turning it on means a `tei-rerank` Deployment, a
bigger node, and `AI_RERANKING_PROVIDER`.

**The ingress turns nginx's response buffering off.** `POST /api/ask` streams,
and buffering would hold every frame until the answer finished — the stream
still arrives, but all at once, at the end.

**An empty `barApiKeys` closes the API rather than opening it.** `VerifyBarKey`
fails closed, so a deploy that forgot the secret is a door nobody can open.
The key belongs on the Krauss Haus server, never in a browser: whoever reads it
spends the AI budget.

First deploy, after the pods are up:
```
kubectl exec -n ask-eddie deploy/app -- php artisan migrate --force

# The corpus is built by the long-running import commands, not by a seeder.
# Restoring a dump taken from a local run is the fast path:
kubectl exec -i -n ask-eddie deploy/db -- \
  pg_restore -U $DB_USERNAME -d $DB_DATABASE --clean --if-exists < laravel.dump
```

## [websockets.thecodeboss.dev](https://websockets.thecodeboss.dev)

Services: 2 (frontend & backend)
Includes: Deployment, Service, and Ingress

To Deploy:
```
kubectl apply -f websockets
```
