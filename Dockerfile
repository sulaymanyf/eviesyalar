# Use the official Nginx image from the Docker Hub
FROM nginx:alpine

# Copy the static files to the Nginx HTML directory
COPY . /usr/share/nginx/html  # Adjusted to copy from the current context

# Expose port 80
EXPOSE 80