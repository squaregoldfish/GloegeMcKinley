library(ncdf4)

MONTH_DAYS <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

moy <- function(month) {
    moy <- (month - 1) %% 12 # First month is February 1982
    if (moy == 0) {
        moy <- 12
    }

    return(moy)
}

# Command line parameters
for (arg in commandArgs()) {
    argset <- strsplit(arg, "=", fixed=TRUE)
    if (!is.na(argset[[1]][2])) {
        if (argset[[1]][1] == "inpath") {
            assign("inpath",argset[[1]][2])
        } else if (argset[[1]][1] == "outpath") {
            assign("outpath",argset[[1]][2])
        }
    }
}

START_MONTH_INDEX <- 36
END_MONTH_INDEX <- 419
YEARS <- (END_MONTH_INDEX - START_MONTH_INDEX + 1) / 12

# Load sea mask
nc <- nc_open("sea.nc")
sea <- ncvar_get(nc, "SEA")
nc_close(nc)

# Read the input data
cat("\033[2K\rReading model data...")
nc_in <- nc_open(inpath)
lons <- ncvar_get(nc_in, "LON25")
lats <- ncvar_get(nc_in, "LAT25")
times <- ncvar_get(nc_in, "TIME")
monthly_pco2 <- ncvar_get(nc_in, "PCO2")
nc_close(nc_in)

# Build output data structure
daily_pco2 <- vector(mode="numeric", length=(length(lons) * length(lats) * YEARS * 365))
daily_pco2[daily_pco2 == 0] <- NA
dim(daily_pco2) <- c(length(lons), length(lats), YEARS * 365)

# Do the thing
current_month <- START_MONTH_INDEX
first_day_index <- 1
while (current_month <= END_MONTH_INDEX) {
    cat("\033[2K\r", current_month, "->", END_MONTH_INDEX)

    month_of_year <- moy(current_month)
    current_month_days <- MONTH_DAYS[month_of_year]

    for (lon in 1:144) {
        for (lat in 1:72) {
            if (sea[lon, lat] != 0) {

                current_value <- monthly_pco2[lon, lat, current_month]
                next_value <- monthly_pco2[lon, lat, current_month + 1]

                change_per_day <- (next_value - current_value) / current_month_days

                current_day_index <- first_day_index
                for (d in 1:current_month_days) {
                    daily_pco2[lon, lat, current_day_index] <- current_value + ((d - 1) * change_per_day)
                    current_day_index <- current_day_index + 1
                }
            }
        }
    }

    current_month <- current_month + 1
    first_day_index <- first_day_index + current_month_days
}



# Create the output file
cat("\033[2K\rWriting output file...")
lon_dim <- ncdim_def("lon", "degrees_east", lons)
lat_dim <- ncdim_def("lat", "degrees_north", lats)
time_dim <- ncdim_def("time", "index", times <- seq(1, YEARS * 365))

pco2_var <- ncvar_def("pco2", "uatm", list(lon_dim, lat_dim, time_dim))

nc_out <- nc_create(outpath, list(pco2_var))
ncvar_put(nc_out, pco2_var, daily_pco2)

nc_close(nc_out)

cat("\n")