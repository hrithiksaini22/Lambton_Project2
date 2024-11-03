# Use the official Node.js image as the base image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port that the React app will run on
EXPOSE 3000

# Command to run the React app
CMD ["npm", "start"]

######### Multistage Docker build and distroless docker image###########
######### Remember to update the port on which the app is runnung in the k8 manifest files and the security gates port in ec2i ###########
#####################################################################################
# Stage 1: Build the React application
# FROM node:16-alpine AS build

# Set working directory
# WORKDIR /app

# Install dependencies
# COPY package*.json ./
# RUN npm install

# Copy the application code and build the app
# COPY . .
# RUN npm run build

# Stage 2: Serve the static files using nginx
# FROM nginx:alpine

# Copy the build output to Nginx’s default html directory
# COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the web server
# EXPOSE 80

# Start Nginx server
# CMD ["nginx", "-g", "daemon off;"]
