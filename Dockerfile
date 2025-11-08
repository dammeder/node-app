ARG NODE_VERSION=22
ARG ALPINE_VERSION=3.21

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}

# Use production node environment by defualt
ENV NODE_ENV production

WORKDIR /usr/src/app

# install dependency 

# node = root/ .npm , python = /.cache/pip ---- Leverage a cache mount /root/.npm to speed up subsequent builds
RUN --mount=type=bind, source=package.json, target=package.json \ 
    --mount=type=bind, source=package-lock.json, target=package-lock.json \
    --mount=type=cache, target=/root/.npm \ 
    npm ci --omit=dev 

# Node image has its own user -- node
USER node 

COPY . . 

EXPOSE 3000

CMD node src/index.js 

