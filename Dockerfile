# Step 1: Build the React app
FROM node:20.17-alpine AS build  

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps  

# Copy the rest of the app files
COPY . .

# Build the React app for production
RUN npm run build

# Step 2: Serve the app using a Node.js server
FROM node:20.17-alpine  

WORKDIR /app

# Install a simple static file server (serve)
RUN npm install -g serve

# Copy build files from the previous stage
COPY --from=build /app/build /app/build

# Expose port 3000
EXPOSE 3000

# Start the app with "serve"
CMD ["serve", "-s", "build", "-l", "3000"]