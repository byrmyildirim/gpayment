# Dockerfile for Railway Deployment
FROM node:20-alpine

# Install necessary system libraries for Prisma and Shopify CLI
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# Set production environment
ENV NODE_ENV=production
ENV PORT=3000

# Copy package files for dependency installation
COPY package.json package-lock.json* ./

# Install all dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install extension dependencies (IMPORTANT to avoid build errors)
RUN cd extensions/payment-based-discount && npm install

# Generate Prisma client
RUN npx prisma generate

# Final build (Remix + Functions)
RUN npm run build

# Expose port (Railway will use PORT env var)
EXPOSE 3000

# Start script
CMD ["npm", "run", "docker-start"]
