# ---------- build stage ----------
FROM node:22-alpine AS build
WORKDIR /app

COPY package*.json ./
# npm install (not npm ci) so a lockfile mismatch cannot break the build
RUN npm install

COPY . .

# EasyPanel passes environment variables as build args
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# ---------- run stage ----------
FROM node:22-alpine
WORKDIR /app
RUN npm install -g serve
COPY --from=build /app/dist ./dist

EXPOSE 3000
# -s makes React routes work on refresh
CMD ["serve", "-s", "dist", "-l", "3000"]
