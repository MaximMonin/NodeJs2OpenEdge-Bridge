# OblikSaas Node2oe Bridge
FROM node:8.10.0-alpine

RUN mkdir -p /app
COPY ./package.json /app/package.json
RUN cd /app && npm install --production

#FROM node  
#RUN npm install express soap xml2js && mkdir /app
ENV NODE_PATH=/app/node_modules

ADD server.js /app
ENTRYPOINT ["node", "/app/server.js"]
EXPOSE 3000
