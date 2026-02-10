ARG NODE_VERSION=18.16.0

FROM node:${NODE_VERSION}
WORKDIR /usr/src/app
COPY tsconfig.json ./
COPY package*.json ./
COPY src ./src
COPY settings ./settings
RUN apt-get update && apt-get install -y net-tools apt-utils libaio1 openjdk-17-jdk && npm install -g typescript && npm install && npm run build-ts

EXPOSE 3000 3003

CMD [ "node", "dist/node-api.js" ]