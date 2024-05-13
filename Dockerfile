FROM node:alpine3.18 as build

ARG VITE_API_BASE_URL
ARG VITE_STRIPE_PUB_KEY

ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
ENV VITE_STRIPE_PUB_KEY=$VITE_STRIPE_PUB_KEY

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build


FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/dist .
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]