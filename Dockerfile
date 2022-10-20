# AS renombra la fase
## FROM node:16-alpine AS base
## RUN mkdir -p /usr/app
## WORKDIR /usr/app


# Prepare static files
## FROM base AS build-front
## COPY ./ ./
## RUN npm ci
## RUN npm run build

# Release
## FROM base AS release
## COPY --from=build-front /usr/app/dist .public
## COPY ./server/package.json ./
## COPY ./server/package-lock.json ./
## COPY ./server/index.js ./
## RUN npm ci --only=production
# RUN cp -r ./dist ./server/public
# RUN cd server
# RUN npm ci

## ENV PORT=8083
## CMD node server/index.js

FROM node:16-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

# Prepare static files
FROM base AS build-front
COPY ./ ./
RUN npm ci
RUN npm run build

# Release
FROM base AS release
COPY --from=build-front /usr/app/dist ./public
COPY ./server/package.json ./
COPY ./server/package-lock.json ./
COPY ./server/index.js ./
RUN npm ci --only=production

ENV PORT=8080
CMD node index.js

