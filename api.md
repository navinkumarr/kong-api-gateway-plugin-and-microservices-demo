# Profile Service

http :3000/profiles?profileids=a1q1q1,aps27

# Search Service

http :8081/search?profileids=a1q1q1,aps27

# Cache Service

jo key=a1q1q1 value=navin expiry=1655698800 | http POST :8080/cache

http :8080/cache/a1q1q1

http :8080/cache

# API Gateway (https://docs.konghq.com/1.1.x/admin-api/)

    # List Services
    http :8001/services
    
    # Create Service
    jo url="http://search-service:8081/" name="search-service"  | http POST :8001/services
    
    # List routes
    http :8001/routes
        
    # List Routes associated to a specific Service
    http :8001/services/search-service/routes
    
    # Create Route on Service
    jo -d. name="search-service-route" service.id="856704f8-aced-4d2e-8207-c75b22d1def7" paths[]="/v1/search" methods[]="GET" | http POST :8001/routes
