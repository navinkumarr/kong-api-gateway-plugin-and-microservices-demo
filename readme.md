# Requirements

**Mandatory tools**

*  [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)


**Optional tools**

* [http](https://httpie.org/)
* [jo](https://github.com/jpmens/jo)

# Application Architecture
    
- **API Gateway (Lua)**

    Used to add authentication with custom authentication plugin and only exposing search service to the world.
    
- **Search Service (Kotlin)**

    Used to fetch profile based on search criteria, in our case using only profileids. Internally uses profile services to fetch profile data and cache service for caching profile data.
    
- **Profile Service (NodeJS)**

    Used to fetch profiles from datasource
    
- **Cache Service (Swift)**

    Used to cache profiles
    
![](assets/api-gatewa-demo-app-architecture-final.jpg)

# Running the application

``sudo docker-compose up``
    
# Setting Up API Gateway

* **Create Service**

``jo url="http://search-service:8081/" name="search-service"  | http POST :8001/services``

* **Create Route on Service**

``jo -d. name="search-service-route" service.id="856704f8-aced-4d2e-8207-c75b22d1def7" paths[]="/v1/search" methods[]="GET" | http POST :8001/routes``
    
    
# Accessing API

``http :8081/search?profileids=a1q1q1``

# External Links

* [kong admin api reference](https://docs.konghq.com/1.0.x/admin-api/)
