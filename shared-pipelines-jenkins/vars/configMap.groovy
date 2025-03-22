def call(Map envVars = [:]) {
    return envVars.collectEntries { key, value ->
        ["$key", "$value"]
    }
}