# Profile Service

http :3000/profiles?profileids=a1q1q1,aps27

# Search Service

http :8080/search?profileids=a1q1q1,aps27

# Cache Service

jo key=a1q1q1 value=navin expiry=1655698800 | http POST :8080/cache

http :8080/cache/a1q1q1

http :8080/cache
