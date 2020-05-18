# OblikSaas Node2oe Bridge
FROM node:8.10.0-alpine

RUN mkdir -p /app
COPY ./package.json /app/package.json
RUN cd /app && npm install --production

ENV NODE_PATH=/app/node_modules

ADD server.js healthcheck.js /app/
ENTRYPOINT ["node", "/app/server.js"]
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=10s CMD node "/app/healthcheck.js"