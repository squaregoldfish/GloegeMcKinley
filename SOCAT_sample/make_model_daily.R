library(ncdf4)

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

# Read the input data
cat("\rReading model data...")
nc_in <- nc_open(inpath)
lons <- ncvar_get(nc_in, "LON25")
lats <- ncvar_get(nc_in, "LAT25")
times <- ncvar_get(nc_in, "TIME")
nc_close(nc_in)

daily_pco2 <- vector(mode="numeric", length=(length(lons) * length(lats) * YEARS * 365))
daily_pco2[daily_pco2 == 0] <- NA
dim(daily_pco2) <- c(length(lons), length(lats), YEARS * 365)



# Create the output file
#cat("\rCreating daily output file")
#lon_dim <- ncdim_def("lon", "degrees_east", lons)
#lat_dim <- ncdim_def("lat", "degrees_north", lats)
#time_dim <- ncdim_def("time", "index", times <- seq(1, YEARS * 365))

#pco2_var <- ncvar_def("pco2", "uatm", list(lon_dim, lat_dim, time_dim))

#nc_out <- nc_create(outpath, list(pco2_var))

nc_close(nc_in)
#nc_close(nc_out)
