# Safe Routes - OSRM Server Setup


## Download South Africa PBF File

1. Go to the Geofabrik download page: [https://download.geofabrik.de/africa/south-africa.html](https://download.geofabrik.de/africa/south-africa.html).
2. Click on the **"south-africa-latest.osm.pbf"** link to download the latest `.pbf` file.
3. Save this file in a directory where you plan to run the OSRM server.


# Set Up OSRM Server
## Run the following commands

1. `sudo apt update`
2. `sudo apt install -y cmake g++ zlib1g-dev libbz2-dev libstxxl1 libstxxl-dev libxml2-dev libboost-all-dev liblua5.2-dev libtbb-dev`

## Install OSRM

1. `git clone https://github.com/Project-OSRM/osrm-backend.git`
2. `cd osrm-backend`

## Build OSRM

Inside the `osrm-backend` folder run

1. `mkdir -p build`
2. `cd build`
3. `cmake ..`
4. `cmake --build .`

## Data Preparation

1. `/path/to/osrm-backend/build/osrm-extract -p /path/to/osrm-backend/profiles/car.lua south-africa-latest.osm.pbf`
2. `/path/to/osrm-backend/build/osrm-partition south-africa-latest.osrm`
3. `/path/to/osrm-backend/build/osrm-customize south-africa-latest.osrm`

## Start the OSRM Server

`/path/to/osrm-backend/build/osrm-routed south-africa-latest.osrm`

By default, the OSRM server will start on port 5000. You can access it at http://localhost:5000

## Test the OSRM Server

`http://localhost:5000/route/v1/driving/-26.195246,28.034088;-26.7117,27.8380?overview=false`

# Run the python server

In the root directly of the project run these commands

1. `cd python`
2. `Python run`

# Run the application

In the root directly of the project run these commands

1. `cd App`
2. `flutter run`

