# Stage 1: Builder
FROM node:18-alpine AS builder
WORKDIR /app

# Install build tools for native modules
RUN apk add --no-cache python3 make g++

# Copy dependency files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source
COPY . .

# Stage 2: Runner
FROM node:18-alpine AS runner
WORKDIR /app

# Copy only necessary files
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app . .

# Expose port
EXPOSE 3000

# Start app
CMD ["npm", "start"]
