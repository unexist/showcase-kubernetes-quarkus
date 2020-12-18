# Install

```Bash
git clone https://github.com/zalando/postgres-operator.git
cd postgres-operator
git checkout v1.5.0
helm install postgres-operator charts/postgres-operator -n operator
```

# Create cluster

```Bash
kubectl create -f postgres.yaml
```

# Verify

```Bash
kubectl describe postgresql
```

# Connect to cluster

```Bash
kubectl port-forward unexist-postgres-0 5432:5432 &!

export PGHOST=localhost
export PGPORT=5432
export PGPASSWORD=$(kubectl get secret unexist.unexist-postgres.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
psql -U unexist -d foo
```

# Learnings

- Min instances is two; otherwise roles and leader election fails
- Metrics are included, but on a different port (pod:8080/)
- Passwords are stored as k8s secret
- Fetching secrets requires the complete name of the secret

