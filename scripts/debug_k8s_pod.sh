#/bin/bash

# echo "Getting pods in namespace..."
# kubectl get pods
# echo "\n"

# echo "Setting POD_NAME to first pod..."
# export POD_NAME=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}')
# echo $POD_NAME
# echo "\n"

# # echo "kubectl describe pod $POD_NAME"
# # kubectl describe pod $POD_NAME

echo "Entering pod for deployment/demoapp-app-prod"
kubectl exec -it deployment/demoapp-app-prod -- /bin/bash
echo "\n"
