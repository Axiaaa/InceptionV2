FROM debian:bookworm

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl gettext && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Creating dirs
RUN mkdir -p /etc/nginx/ssl

#Generating SSL key & certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lcamerly1.eeee.com/CN=lcamerly1.eeee.com"

#Copy conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN echo "Starting NGinx"

CMD ["nginx", "-g", "daemon off;"]
