# Delete the KIND cluster
kind delete cluster --name my-cluster

# Create the KIND cluster
kind create cluster --config kubernetes/kind-cluster.yaml --name my-cluster


# Install Helm
if ! command -v helm &> /dev/null
then
    echo "Helm could not be found, installing..."
    brew install helm
fi

# Update Helm dependencies
helm dependency update ./helm/postgres

# Deploy PostgreSQL using Helm with specified options
helm upgrade -i my-postgres ./helm/postgres \
--namespace postgres-namespace --create-namespace \
-f ./helm/postgres/values.yaml

# Deploy NGINX and HashiCorp Echo using Helm with specified options
helm upgrade -i my-nginx ./helm/nginx \
--namespace nginx-namespace --create-namespace \
-f ./helm/nginx/values.yaml

echo "PostgreSQL has been installed and is running."

# Verify installation
kubectl get pods --namespace postgres-namespace
kubectl get svc --namespace postgres-namespace
kubectl get pods --namespace nginx-namespace
kubectl get svc --namespace nginx-namespace

# Verify port mapping
nc -zv localhost 30007
nc -zv localhost 30008
nc -zv localhost 30009