FROM node:10.15.3

WORKDIR /src/build-your-own-radar
COPY package.json ./
RUN npm install
COPY . ./
CMD ["npm","run","dev"]