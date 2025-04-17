# Stage 1: Build the Angular app
FROM node:22 AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source code
COPY . .

# Build Angular app in production mode
RUN npm run build --prod

# Stage 2: Serve the app using nginx
FROM nginx:alpine

# Copy built app from Stage 1
COPY --from=builder /app/dist/sample-angular /usr/share/nginx/html

# Remove default nginx config and replace with custom one (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]