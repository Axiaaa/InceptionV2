FROM alpine:3.22

RUN apk add --no-cache \
        curl \ 
        nodejs \ 
        npm \
    && rm -f /var/cache/apk/*


WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

CMD ["npm", "run", "dev"]