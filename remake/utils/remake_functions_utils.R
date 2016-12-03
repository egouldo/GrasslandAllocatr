# Define Functions
load_Netica_LicenseKey <- function(path = "./data/LicenseKey"){
        load(GrasslandAllocatr::f_path(path))
        RNetica::StartNetica(license = LicenseKey)
}

# Stop and Restart Netica with License Key
StopNetica()
load_Netica_LicenseKey()