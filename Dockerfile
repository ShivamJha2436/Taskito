# Dockerfile
# Use Node.js image to build the application
FROM node:18 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Use a minimal image to run the application
FROM node:18-slim

# Set the working directory
WORKDIR /app

# Copy built application from the builder stage
COPY --from=builder /app/.next .next
COPY --from=builder /app/public public
COPY --from=builder /app/package*.json ./

# Install production dependencies
RUN npm install --only=production

# Start the application
CMD ["npm", "start"]

# Expose port 3000
EXPOSE 3000
