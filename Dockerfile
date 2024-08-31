# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application to the container
COPY . .

# Build the application for production
RUN npm run build

# Stage 2: Serve the application using NGINX
FROM nginx:alpine

# Copy the built files from the previous stage to NGINX's default serving directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to allow access
EXPOSE 80

# Command to start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
