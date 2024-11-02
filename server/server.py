import http.server
import socketserver
import os

class CORSHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Allow all origins
        self.send_header("Access-Control-Allow-Origin", "*")
        # Allow specific HTTP methods
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        # Optionally, allow specific headers
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization")
        # Call the parent class's end_headers method
        super().end_headers()

# Set the port number
PORT = 11690

# Specify the directory you want to serve files from
DIRECTORY = "C:/Users/Robotica/video_server/scouting videos test"

# Change the working directory
os.chdir(DIRECTORY)

# Create the server
with socketserver.TCPServer(("1.16.90.1", PORT), CORSHTTPRequestHandler) as httpd:
    print(f"Serving HTTP on port {PORT} from directory: {DIRECTORY}...")
    httpd.serve_forever()
