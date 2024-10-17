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
--namespace my-namespace --create-namespace \
-f ./helm/postgres/values.yaml

echo "PostgreSQL has been installed and is running."

# Verify installation
kubectl get pods --namespace my-namespace
kubectl get svc --namespace my-namespace

nc -zv localhost 30007