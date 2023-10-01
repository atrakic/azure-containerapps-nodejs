FROM node:20 AS build-env
ADD . /app
WORKDIR /app
RUN npm install --omit=dev


FROM gcr.io/distroless/nodejs20-debian11
COPY --from=build-env /app /app
WORKDIR /app
ARG PORT=3000
ENV PORT $PORT
EXPOSE $PORT
CMD ["app.js"]
