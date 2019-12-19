En tant qu'admin ou user habilité à soumettre des csr

```bash
kubectl apply -f csr.yaml
kubectl get csr
```

En tant qu'admin ou user habilité à valider des csr

```bash
kubectl get csr
kubectl certificate approve pcavezzan
```

En tant qu'admin ou user habilité à soumettre des csr

```bash
kubectl get csr 
kubectl get csr pcavezzan -o yaml
kubectl get csr pcavezzan -o jsonpath='{.status.certificat}' | base64 --decode > pcavezzan.crt
```

Puis générer le bon kubeconfig.

### Ressources utiles

* https://kubernetes.io/fr/docs/concepts/cluster-administration/certificates/
* https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/
* https://medium.com/better-programming/k8s-tips-give-access-to-your-clusterwith-a-client-certificate-dfb3b71a76fe


