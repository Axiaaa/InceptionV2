FROM alpine:3.22

RUN apk add curl nodejs npm

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

CMD ["npm", "run", "dev"]