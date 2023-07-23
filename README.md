# Redirect

A tiny little app to help with redirects. Specify the redirect location in the `REDIRECT_LOCATION` environment variable.

A Docker image is provided for use with Kubernetes, Traefik, Compose, or your favorite way to run Docker containers.

## Deploying in Kubernetes

The following yaml demonstrates how this app might be deployed on Kubernetes to redirect `www` requests to their non-www equivalents

```
apiVersion: v1
kind: Service
metadata:
  name: www-app
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 8080
      protocol: TCP
  selector:
    app: www-app
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: www-app-deployment
  labels:
    app: www-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: www-app
  template:
    metadata:
      labels:
        app: www-app
    spec:
      containers:
        - name: www-app
          image: ghcr.io/fullqueuedeveloper/redirect:1.0
          env:
            - name: REDIRECT_LOCATION
              value: https://fullqueuedeveloper.com
          livenessProbe:
            httpGet:
              path: /healthy
              port: 8080
            initialDelaySeconds: 3
            periodSeconds: 600
```

## License

BSD

## About the author

[FullQueueDeveloper](https://github.com/FullQueueDeveloper) streams on Twitch. Further projects are available on [FullQueueDeveloper.com](https://FullQueueDeveloper.com). If you find his projects interesting or helpful, consider [sponsoring him on GitHub](https://github.com/sponsors/FullQueueDeveloper).
