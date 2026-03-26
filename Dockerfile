# Dockerfile for Railway Deployment
FROM node:20-alpine

# Install necessary system libraries for Prisma and Shopify CLI
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# Set production environment
ENV NODE_ENV=production
ENV PORT=3000

# Copy package files for dependency installation (Root + Extension)
COPY package*.json ./
COPY extensions/payment-based-discount/package*.json ./extensions/payment-based-discount/

# Install all dependencies (Root handles workspaces)
RUN npm install

# Copy the rest of the application code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Final build (Remix + Functions)
RUN npm run build

# Expose port (Railway will use PORT env var)
EXPOSE 3000

# Start script
CMD ["npm", "run", "docker-start"]
