from flask import Flask, request, jsonify
import requests
import polyline
import math
from typing import List, Tuple, Optional

app = Flask(__name__)

# Define the OSRM routing service URL
OSRM_SERVER_URL = 'http://localhost:5001/route/v1/driving/'

# Coordinates for the center of the area
# AREA_LAT = -26.735658287344435
# AREA_LNG = 27.85464473068714
# AREA_RADIUS = 100  # in meters

def haversine(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    R = 6371000  # Radius of the Earth in meters
    
    # Convert degrees to radians
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lng2 - lng1)
    
    # Haversine formula
    a = math.sin(delta_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    
    return R * c

def is_inside(
        path: List[Tuple[float, float]],
        crime: Tuple[float, float],
        radius: float
    ) -> Tuple[bool, Optional[int]]:
    for i, (lat, lng) in enumerate(path):
        distance_to_area = haversine(lat, lng, crime[0], crime[1])
        if distance_to_area <= radius:
            return True, i
    return False, None


def get_alternative_route(
        start_lat: float, start_lng: float, goal_lat: float, goal_lng: float, 
        avoid_point: Tuple[float, float],
        crime: Tuple[float, float],
        radius: float
    ) -> List[Tuple[float, float]]:
    avoid_lat, avoid_lng = avoid_point
    
    goal_bearing = math.degrees(math.atan2(
        goal_lng - avoid_lng,
        goal_lat - avoid_lat
    ))
    
    angles = []
    base_angles = [
        -135, -120, -105, -90, -75, -60, -45, -30, -15,  # Left side angles
        0,  # Straight ahead
        15, 30, 45, 60, 75, 90, 105, 120, 135  # Right side angles
    ]
    
    for angle in base_angles:
        angles.append((goal_bearing + angle) % 360)
    
    radius_multipliers = [1.5, 2.0, 2.5]
    
    for radius_mult in radius_multipliers:
        current_radius = radius * radius_mult
        
        for angle in angles:
            lat = avoid_lat + (current_radius / 111320) * math.cos(math.radians(angle))
            lng = avoid_lng + (current_radius / (111320 * math.cos(math.radians(avoid_lat)))) * math.sin(math.radians(angle))
            
            coordinates = f"{start_lng},{start_lat};{lng},{lat};{goal_lng},{goal_lat}"
            url = OSRM_SERVER_URL + coordinates + '?overview=full&steps=true'
            
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    data = response.json()
                    path = polyline.decode(data['routes'][0]['geometry'])
                    is_intersecting, _ = is_inside(path, crime, radius)
                    
                    if not is_intersecting:
                        print(f"Found valid route with angle {angle} and radius multiplier {radius_mult}")
                        return path
            except Exception as e:
                print(f"Error trying waypoint at angle {angle}: {e}")
                continue
    
    return [] 


@app.route('/api/path', methods=['POST'])
def get_path():
    try:
        data = request.get_json()
        start_lat = data.get('start_lat')
        start_lng = data.get('start_lng')
        goal_lat = data.get('goal_lat')
        goal_lng = data.get('goal_lng')
        crime_lat = data.get('crime_lat')
        crime_lng = data.get('crime_lng')
        crime_radius = data.get('crime_radius')

        if not all([start_lat, start_lng, goal_lat, goal_lng]):
            return jsonify({'error': 'Missing required parameters'}), 400

        coordinates = f'{start_lng},{start_lat};{goal_lng},{goal_lat}'
        url = OSRM_SERVER_URL + coordinates + '?overview=full&steps=true'
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            route_geometry = data['routes'][0]['geometry']
            path = polyline.decode(route_geometry)
            
            is_intersecting, intersection_idx = is_inside(path, [crime_lat, crime_lng], crime_radius)
            
            if is_intersecting:
                avoid_point = path[max(0, intersection_idx - 1)] 
                
                alternative_path = get_alternative_route(
                    start_lat, 
                    start_lng, 
                    goal_lat, 
                    goal_lng, 
                    avoid_point, 
                    [crime_lat, crime_lng], 
                    crime_radius
                )
                
                if alternative_path:
                    return jsonify({'path': alternative_path})
                else:
                    print('No alternative route found!')
                    return jsonify({'path': path})
            
            return jsonify({'path': path})
        else:
            return jsonify({'error': f'OSRM service error: {response.status_code}'}), 500
            
    except Exception as e:
        print(e)
        return jsonify({'error': f'Error processing the request: {str(e)}'}), 500
    
if __name__ == '__main__':
    app.run(debug=True)