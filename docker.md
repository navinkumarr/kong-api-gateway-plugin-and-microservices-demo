# Rebuild single service

    sudo docker-compose up --no-deps --force-recreate --no-start  --build api-gateway

# Run docker 

    sudo docker-compose up
    
# Build single service

    sudo docker build -t api-gateway-demo_cache-service:latest . --build-arg env=docker
    
    sudo docker run --net=host api-gateway-demo_cache-service:latest
