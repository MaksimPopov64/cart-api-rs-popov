FROM node:12.16.3 as build_image

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm i && npm cache clean --force

COPY tsconfig*.json ./
COPY ./src ./src
RUN npm run build
RUN npm prune --production

FROM node:12.16.3-alpine

WORKDIR /app

COPY package*.json ./
RUN npm i --production

COPY --from=build_image /usr/src/app/dist ./dist

ENV NODE_ENV=production
ENV PORT=8080

# Bind to the port
EXPOSE 8080
CMD [ "npm", "run", "start:prod" ]
