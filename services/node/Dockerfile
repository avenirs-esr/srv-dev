FROM node:18.16.0
WORKDIR /usr/src/app
COPY tsconfig.json ./
COPY package*.json ./
COPY lib ./lib
COPY src ./src
ENV http_proxy=http://cache.univ-tln.fr:3128/
ENV https_proxy=http://cache.univ-tln.fr:3128/
RUN apt-get update && apt-get install -y net-tools apt-utils libaio1 openjdk-17-jdk && npm install -g typescript && npm install && npm run build-ts 
#VOLUME /usr/src/app/logs

EXPOSE 3000

CMD [ "node", "dist/src/audit-backend.js" ]