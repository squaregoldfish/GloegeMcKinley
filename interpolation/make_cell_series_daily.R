library(ncdf4)

# Command line parameters
for (arg in commandArgs()) {
    argset <- strsplit(arg, "=", fixed=TRUE)
    if (!is.na(argset[[1]][2])) {
        if (argset[[1]][1] == "sample") {
            assign("SAMPLE_FILE",argset[[1]][2])
        } else if (argset[[1]][1] == "model") {
            assign("MODEL_FILE",argset[[1]][2])
        } else if (argset[[1]][1] == "output") {
            assign("OUTPUT_ROOT",argset[[1]][2])
        }
    }
}

cat("Reading model file...")
nc <- nc_open(MODEL_FILE)
lons <- ncvar_get(nc, "lon")
lats <- ncvar_get(nc, "lat")
times <- ncvar_get(nc, "time")
model_pco2 <- ncvar_get(nc, "pco2")
nc_close(nc)

cat("\r\033[KSampling model output...")

# Build sampled data array
sampled_pco2 <- vector(mode="numeric", length=length(model_pco2))
dim(sampled_pco2) <- c(length(lons), length(lats), length(times))
sampled_pco2[sampled_pco2 == 0] <- NA

conn <- file(SAMPLE_FILE,open="r")

line <- readLines(conn,n=1)
line <- readLines(conn,n=1)
line_count <- 1

while (length(line) > 0) {
    fields <- unlist(strsplit(line, "\t"))
    time_index <- as.integer(fields[2])
    lon_index <- as.integer(fields[3])
    lat_index <- as.integer(fields[4])

    sampled_pco2[lon_index, lat_index, time_index] <- model_pco2[lon_index, lat_index, time_index]

    line <- readLines(conn,n=1)
    line_count <- line_count + 1
}

# Write cell series files
dir.create(file.path(OUTPUT_ROOT, "cell_series_daily"), showWarnings = FALSE)

for (lon_loop in 1:144) {
    for (lat_loop in 1:72) {
        cat("\r\033[KWriting series file ", lon_loop, " ", lat_loop, sep="")
        sink(paste(OUTPUT_ROOT,"/cell_series_daily/cell_series_", lon_loop, "_", lat_loop, ".csv", sep=""))
        for (time_loop in 1:length(times)) {
            cat(time_loop, ",", sampled_pco2[lon_loop, lat_loop, time_loop], "\n", sep="")
        }
        sink()
    }
}

cat("\r\033[KWriting sampled netCDF file...")
lon_dim <- ncdim_def("LON", "degrees_east", lons)
lat_dim <- ncdim_def("LAT", "degrees_north", lats)
time_dim <- ncdim_def("TIME", "year", times)

pco2_var <- ncvar_def("pco2", "uatm", list(lon_dim, lat_dim, time_dim), -999, prec="double")

nc <- nc_create(paste(OUTPUT_ROOT, "/daily.nc", sep=""), list(pco2_var))
ncvar_put(nc, "pco2", sampled_pco2)
nc_close(nc)

cat("\n")
