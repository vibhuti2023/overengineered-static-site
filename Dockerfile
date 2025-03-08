# --- Build Stage ---
FROM node:18 AS builder
WORKDIR /app

# Copy package files and install dependencies (if needed)
COPY package.json package-lock.json ./  
RUN npm ci  

# Copy all website files
COPY . .  

# --- Runtime Stage ---
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy static files directly (NO build step needed)
COPY --from=builder /app/public .  

# Expose port and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

