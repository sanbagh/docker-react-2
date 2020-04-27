FROM node:alpine as builder

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

FROM nginx
COPY --from=builder /app/build/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY --from=builder /app/build /usr/share/nginx/html
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'