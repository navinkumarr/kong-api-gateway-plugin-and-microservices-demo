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

# Project structure

        ├── api-gateway (API Gateway Application)
        ├── api.md
        ├── assets
        ├── cache-service (Cache Service Application)
        ├── docker-compose.yml
        ├── docker.md (Contains helpful docker commands)
        ├── profile-service (Profile Service Application)
        ├── README.md
        └── search-service (Search Service Application)

* **API Gateway**

        api-gateway
        ├── docker-entrypoint.sh
        ├── Dockerfile
        └── kong
            └── plugins
                └── demoauth
                    ├── constants.lua
                    ├── handler.lua (access method of the handler is the entrypoint of the plugin)
                    ├── schema.lua (schema defines the configuration needed by this plugin)
                    └── utils.lua
            
* **Cache Service**

        cache-service
        ├── cloud.yml
        ├── CONTRIBUTING.md
        ├── Dockerfile
        ├── Package.resolved
        ├── Package.swift
        ├── Public
        ├── README.md
        ├── Sources
        │   ├── App
        │   │   ├── app.swift
        │   │   ├── boot.swift
        │   │   ├── configure.swift
        │   │   ├── Controllers
        │   │   │   └── CacheController.swift (Controller contains logic to store cache)
        │   │   ├── Models
        │   │   │   └── Cache.swift (Cache model)
        │   │   └── routes.swift (Contains routes of the API)
        │   └── Run
        │       └── main.swift ()
        └── Tests
            ├── AppTests
            │   └── AppTests.swift
            └── LinuxMain.swift


* **Profile Service**

        profile-service
        ├── Dockerfile
        ├── index.js (Contains profile server)
        ├── node_modules
        ├── package.json
        ├── package-lock.json
        └── profiles.json (Json file acting as database)

* **Search Service**

        search-service
        ├── build
        ├── build.gradle
        ├── Dockerfile
        ├── gradle
        ├── gradlew
        ├── gradlew.bat
        ├── HELP.md
        ├── settings.gradle
        └── src
            ├── main
            │   ├── kotlin
            │   │   └── com
            │   │       └── shaadi
            │   │           └── search
            │   │               ├── SearchApplication.kt (Main application)
            │   │               └── SearchController.kt (Contains routing and business logic)
            │   └── resources
            │       ├── application.properties (application config)
            │       ├── static
            │       └── templates
            └── test
                └── kotlin
                    └── com
                        └── shaadi
                            └── search

# Running the application

``sudo docker-compose up``
    
# Setting Up API Gateway

* **Create Service**

``jo url="http://search-service:8081/" name="search-service"  | http POST :8001/services``

* **Create Route on Service**

``jo -d. name="search-service-route" service.id="856704f8-aced-4d2e-8207-c75b22d1def7" paths[]="/v1/search" methods[]="GET" | http POST :8001/routes``
    
* **Activate auth plugin on Search Service**

``jo name=demoauth | http POST :8001/services/search-service/plugin``
    
# Accessing API without activating auth plugin

``http :8081/search?profileids=a1q1q1``

# Accessing API With authkey header after activating auth plugin

``http :8000/v1/search?profileids=a1q1q1 authkey:"hackfest|demo|"``

# External Links

* [kong admin api reference](https://docs.konghq.com/1.0.x/admin-api/)

