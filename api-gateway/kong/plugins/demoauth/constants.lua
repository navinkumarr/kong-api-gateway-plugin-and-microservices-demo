return {
  PRIORITY = 1002,
  VERSION = "1.0.0",
  MESSAGE = {
    AUTHORIZATION_REQUIRED = "Authorization Required",
    INVALID_CONFIG = "Invalid plugin configuration",
  },
  STATUS = {
    UNAUTHORIZED = 401,
    INTERNAL_SERVER_ERROR = 500
  },
  REDIS = {
      MAX_IDLE_TIMEOUT = 10000,
      POOL_SIZE = 100
  },
}
