# Stage 1: Build dependencies
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install dependencies (including dev for build)
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the application (if you have a build step, e.g. React/TypeScript)
RUN npm run build

# Stage 2: Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Install only production dependencies
RUN npm ci --only=production

# Expose application port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
