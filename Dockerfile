# Use nginx to serve our HTML page
FROM nginx:alpine

# Copy our HTML file into nginx
COPY app/index.html /usr/share/nginx/html/index.html

# Open port 80
EXPOSE 80
