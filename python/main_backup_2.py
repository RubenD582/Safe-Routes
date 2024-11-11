from math import radians, sin, cos, sqrt, atan2
import math
import time
import matplotlib.pyplot as plt
import requests
import polyline
import osmnx as ox
import networkx as nx
import numpy as np
from shapely import Point
from geopy.distance import geodesic
import multiprocessing as mp
from functools import reduce
import warnings
from flask import Flask, jsonify, request
import aiohttp
import asyncio
import os

app = Flask(__name__)
warnings.filterwarnings("ignore", category=FutureWarning)

road_speeds = {
    'residential': 60,
    'tertiary': 100,
    'primary': 120,
    'primary_link': 120,
    'secondary': 100,
}

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


async def download_graph(session, bbox):
    north, south, east, west = bbox
    graph_hash = hash(tuple(bbox))
    filename = f"cache/graph_{graph_hash}.graphml"

    if os.path.exists(filename):
        return ox.load_graphml(filename)

    graph = ox.graph_from_bbox(south, north, west, east, network_type='drive')
    ox.save_graphml(graph, filename)
    return graph


async def download_all_graphs(bboxes):
    async with aiohttp.ClientSession() as session:
        tasks = [download_graph(session, bbox) for bbox in bboxes]
        return await asyncio.gather(*tasks)


# @app.route('/api/path', methods=['POST'])
# async def get_path():
#     BOX_SIZE = 100  # Size of each region in km

#     data = request.json

#     start_lat = float(data.get('start_lat'))
#     start_lng = float(data.get('start_lng'))
#     goal_lat  = float(data.get('goal_lat'))
#     goal_lng  = float(data.get('goal_lng'))
#     crime_lat = float(data.get('crime_lat'))
#     crime_lng = float(data.get('crime_lng'))
#     radius    = float(data.get('radius'))

#     start_time = time.time()

#     start = Node(start_lng, start_lat)
#     goal = Node(goal_lng, goal_lat)
#     crime = Node(crime_lng, crime_lat)

#     north = max(start.lat, goal.lat)
#     south = min(start.lat, goal.lat)
#     east = max(start.lng, goal.lng)
#     west = min(start.lng, goal.lng)

#     lat_distance = geodesic((north, west), (south, west)).km
#     lng_distance = geodesic((north, west), (north, east)).km

#     lat_splits = max(int(lat_distance // BOX_SIZE), 1)
#     lng_splits = max(int(lng_distance // BOX_SIZE), 1)

#     lat_step = (north - south) / lat_splits
#     lng_step = (east - west) / lng_splits

#     bboxes = [
#         (
#             north - i * lat_step,
#             north - (i + 1) * lat_step,
#             west + (j + 1) * lng_step,
#             west + j * lng_step
#         )
#         for i in range(lat_splits)
#         for j in range(lng_splits)
#     ]

#     # Use asyncio to download all graphs concurrently
#     graphs = await download_all_graphs(bboxes)

#     # Combine all graphs into one
#     G = graphs[0]
#     for graph in graphs[1:]:
#         G = nx.compose(G, graph)

#     end_time = time.time()  # End the timer
#     execution_time = end_time - start_time
#     print(f"Execution time: {execution_time:.2f} seconds")

#     # Adjust edge lengths near crime areas
#     for node, data in G.nodes(data=True):
#         if within(crime.lat, crime.lng, radius, Node(data['x'], data['y'])):
#             for neighbor in G.neighbors(node):
#                 G[node][neighbor][0]['length'] *= 2

#     start_node = ox.distance.nearest_nodes(G, start.lng, start.lat)
#     goal_node = ox.distance.nearest_nodes(G, goal.lng, goal.lat)

#     # Find the shortest path using Dijkstra's algorithm
#     shortest_path = nx.shortest_path(G, source=start_node, target=goal_node, weight='length')

#     # Calculate metadata (distance, time)
#     total_distance = 0
#     total_hours = 0
#     for node, neighbor in zip(shortest_path[:-1], shortest_path[1:]):
#         edge_data = G[node][neighbor][0]
#         speed = road_speeds.get(edge_data['highway'], 30)  # Default speed is 30 km/h

#         distance = edge_data['length'] / 1000  # Convert from meters to kilometers
#         time_hours = distance / speed  # Time in hours

#         total_distance += distance
#         total_hours += time_hours

#     hours = math.floor(total_hours)
#     minutes = math.floor((total_hours - hours) * 60)

#     data = {
#         "path": [[G.nodes[node]['y'], G.nodes[node]['x']] for node in shortest_path],
#         "distance": round(total_distance, 2),
#         "hours": hours,
#         "minutes": minutes
#     }

#     return jsonify(data)
   
#     # fig, ax = plt.subplots(figsize=(12, 8))
#     # ox.plot_graph(G, ax=ax, show=False, close=False)
#     # ox.plot_graph_route(G, shortest_path, ax=ax, route_linewidth=6, node_size=0, edge_color='r')
#     # plt.title('Shortest Path in the Graph')
#     # plt.show()

#     # return shortest_path_coordinates


# Function to get the shortest path using OSM data
async def get_shortest_path(start_lat, start_lng, goal_lat, goal_lng, crime_lat, crime_lng, radius):
    # Define the bounding box to cover both start and goal locations
    north = max(start_lat, goal_lat) + 0.01  # Add a buffer
    south = min(start_lat, goal_lat) - 0.01
    east = max(start_lng, goal_lng) + 0.01
    west = min(start_lng, goal_lng) - 0.01
    
    # Fetch the OSM graph for the defined bounding box
    graph = ox.graph_from_bbox(north, south, east, west, network_type='all')
    
    # Convert start and goal locations to node IDs in the graph
    start_node = ox.distance.nearest_nodes(graph, X=start_lng, Y=start_lat)
    goal_node = ox.distance.nearest_nodes(graph, X=goal_lng, Y=goal_lat)
    
    # Get the crime location (we can check distances to nodes or edges)
    crime_coords = (crime_lat, crime_lng)
    
    # Optional: Remove nodes within the crime radius
    nodes_to_remove = []
    for node, data in graph.nodes(data=True):
        node_coords = (data['y'], data['x'])
        if geodesic(node_coords, crime_coords).meters < radius:
            nodes_to_remove.append(node)
    
    # Remove the nodes in the crime radius
    graph.remove_nodes_from(nodes_to_remove)

    # Compute the shortest path using Dijkstra's algorithm
    shortest_path = nx.shortest_path(graph, source=start_node, target=goal_node, weight='length')

    # Convert node IDs to lat/lng coordinates
    path_coords = [(graph.nodes[node]['y'], graph.nodes[node]['x']) for node in shortest_path]
    
    # Return the path coordinates and its length
    path_length = sum(
        ox.distance.great_circle_vec(
            graph.nodes[shortest_path[i]]['y'], graph.nodes[shortest_path[i]]['x'],
            graph.nodes[shortest_path[i + 1]]['y'], graph.nodes[shortest_path[i + 1]]['x']
        ) for i in range(len(shortest_path) - 1)
    )
    
    return path_coords, path_length

@app.route('/api/path', methods=['POST'])
async def get_path():
    data = request.json

    # Extract input data
    start_lat = float(data.get('start_lat'))
    start_lng = float(data.get('start_lng'))
    goal_lat  = float(data.get('goal_lat'))
    goal_lng  = float(data.get('goal_lng'))
    crime_lat = float(data.get('crime_lat'))
    crime_lng = float(data.get('crime_lng'))
    radius    = float(data.get('radius'))

    # Get the shortest path using OpenStreetMap data
    path, path_length = await get_shortest_path(start_lat, start_lng, goal_lat, goal_lng, crime_lat, crime_lng, radius)

    print(path)

    # Return the path and its total length
    return jsonify({
        'path': path,
        'path_length': path_length
    })


if __name__ == '__main__':
    app.run(debug=True)


# if __name__ == "__main__":
#     start = Node(27.807695, -26.703421)
#     goal = Node(27.931944, -26.673611)
#     # start = Node(27.84833, -26.28669)
#     # goal = Node(27.87794, -26.24528)
#     zone = Node(27.865, -26.2611111)

#     coordinates = ((start.lng, start.lat), (goal.lng, goal.lat))
    
#     print(get_path(coordinates, zone, 1000))

#     # name = "Moroka, Soweto, Gauteng, South"
#     # geolocator = Nominatim(user_agent="my_geocoder")
#     # location = geolocator.geocode(name)
#     # if location:
#     #     print("Location: ", location.latitude, location.longitude)
#     # else:
#     #     print(None)


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
