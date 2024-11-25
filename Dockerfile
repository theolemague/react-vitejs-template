# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only package files first to leverage cache
COPY package*.json ./

# Install dependencies with clean install and frozen lockfile
RUN npm ci

# Copy source files
COPY . .

# Build the app
RUN npm run build

# Serve stage
FROM node:20-alpine

WORKDIR /app

# Install serve globally in the new stage
RUN npm install -g serve

# Copy only the built files from builder
COPY --from=builder /app/dist ./dist

# Expose port 8080
EXPOSE 8080

# Use non-root user for better security
USER node

# Start the application
CMD ["serve", "-s", "dist", "-l", "8080"]
