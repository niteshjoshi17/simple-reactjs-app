# Step 1: Build the React app using Node
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

# Step 2: Serve the build files with Nginx
FROM nginx:alpine  

# Copy the build folder into Nginx's HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 3000 instead of 80
EXPOSE 3000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
