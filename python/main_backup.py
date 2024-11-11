from math import radians, sin, cos, sqrt, atan2
import time
import matplotlib.pyplot as plt
import requests
import polyline
import osmnx as ox
import networkx as nx
import numpy as np
import openrouteservice
from openrouteservice import convert
from shapely import Point
from geopy.distance import geodesic
import multiprocessing as mp
from functools import reduce
import warnings

warnings.filterwarnings("ignore", category=FutureWarning)
client = openrouteservice.Client(key='5b3ce3597851110001cf6248b74d3b28a02b49bfba9f6a512e23845d', timeout=60)


class Node:
    def __init__(self, lng, lat):
        self.lat = lat
        self.lng = lng
        self.parent = None
        self.g = 0
        self.h = 0
        self.f = 0

def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0

    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)

    a = sin(dlat / 2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = R * c

    return distance * 1000


def within(circle_lat, circle_lon, circle_radius, coordinate):
    distance = haversine(circle_lat, circle_lon, coordinate.lat, coordinate.lng)

    return distance <= circle_radius


def get_bounding_box(center, radius):
    lat, lon = center.lat, center.lng
    delta = radius / 111320 
    return (lat - delta, lat + delta, lon - delta / np.cos(np.radians(lat)), lon + delta / np.cos(np.radians(lat)))

# route = client.directions(coordinates, profile='driving-car', format='geojson')
    # geometry = route['features'][0]['geometry']['coordinates']
    
    # danger_zone = Point(crime.lng, crime.lat).buffer(radius)
    
    # polylines = []
    # for coordinate in geometry:
    #     location = Point(coordinate[0], coordinate[1])
    #     if danger_zone.contains(location):
    #         # Add coordinates to the list of points if they are within the danger zone
    #         polylines.append([coordinate[1], coordinate[0]])  # Adjust order for lat/lng
    #         inside = True

    # if inside:

def download_graph(bbox):
    north, south, east, west = bbox
    return ox.graph_from_bbox(south, north, west, east, network_type='drive')


def get_path(coordinates, crime, radius):
    BOX_SIZE = 10

    start_time = time.time()

    start = Node(coordinates[0][0], coordinates[0][1])
    goal = Node(coordinates[1][0], coordinates[1][1])

    north = max(start.lat, goal.lat)
    south = min(start.lat, goal.lat)
    east = max(start.lng, goal.lng)
    west = min(start.lng, goal.lng)

    lat_distance = geodesic((north, west), (south, west)).km
    lng_distance = geodesic((north, west), (north, east)).km

    lat_splits = max(int(lat_distance // BOX_SIZE), 1)
    lng_splits = max(int(lng_distance // BOX_SIZE), 1)

    lat_step = (north - south) / lat_splits
    lng_step = (east - west) / lng_splits

    bboxes = []
    for i in range(lat_splits):
        for j in range(lng_splits):
            tile_north = north - i * lat_step
            tile_south = tile_north - lat_step
            tile_west = west + j * lng_step
            tile_east = tile_west + lng_step
            bboxes.append((tile_north, tile_south, tile_east, tile_west))

    print(f"TOTAL THREADS: {mp.cpu_count()}")
    with mp.Pool(len(bboxes)) as pool:
        graphs = pool.map(download_graph, bboxes)

    G = reduce(nx.compose, graphs)

    end_time = time.time()  # End the timer
    execution_time = end_time - start_time
    print(f"Execution time: {execution_time:.2f} seconds")

    # # G = ox.graph_from_bbox(north, south, east, west, network_type='drive')
    # for node, data in G.nodes(data=True):
    #     if within(crime.lat, crime.lng, radius, Node(data['y'], data['x'])):
    #         for neighbor in G.neighbors(node):
    #             G[node][neighbor][0]['length'] *= 2

    # start_node = ox.distance.nearest_nodes(G, coordinates[0][0], coordinates[0][1]) # (lat, lng)
    # goal_node = ox.distance.nearest_nodes(G, coordinates[1][0], coordinates[1][1])  # (lat, lng)

    # shortest_path = nx.shortest_path(G, start_node, goal_node, weight='length')

    # shortest_path_coordinates = [[G.nodes[node]['y'], G.nodes[node]['x']] for node in shortest_path]

    fig, ax = ox.plot_graph(G, node_color='blue', node_size=5, edge_color='black', bgcolor='white')

    plt.tight_layout()
    plt.show()

    # return shortest_path_coordinates

if __name__ == "__main__":
    start = Node(27.807695, -26.703421)
    goal = Node(28.034088, -26.195246)
    zone = Node(27.865, -26.2611111)

    coordinates = ((start.lng, start.lat), (goal.lng, goal.lat))
    
    print(get_path(coordinates, zone, 1000))

    # name = "Moroka, Soweto, Gauteng, South"
    # geolocator = Nominatim(user_agent="my_geocoder")
    # location = geolocator.geocode(name)
    # if location:
    #     print("Location: ", location.latitude, location.longitude)
    # else:
    #     print(None)


# Define the place name
# import osmnx as ox
# import networkx as nx
# import geopy.distance
# import matplotlib.pyplot as plt

# place_name = "Midrand, Johannesburg South, Gauteng, South Africa"

# def get_street_graph(start_point, goal_point):
#     # Retrieve street network from OSM
#     G = ox.graph_from_place(place_name, network_type='drive')
#     return G

# # Example start and goal points
# start_point = (-26.703421, 27.807695)
# goal_point = (-26.810190, 27.827724)

# street_graph = get_street_graph(start_point, goal_point)

# # Plot the street graph
# fig, ax = ox.plot_graph(street_graph, node_color='blue', node_size=5, edge_color='black', bgcolor='white')

# plt.tight_layout()
# plt.show()







# decoded_geometry = convert.decode_polyline(geometry)

# print("Route geometry (decoded):")
# for coord in decoded_geometry['coordinates']:
#     print(coord)
