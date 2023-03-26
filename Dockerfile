FROM node:14-alpine AS builder
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
RUN npm run build

FROM python:3.8-slim-buster
WORKDIR /app
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
COPY --from=builder /app/build /app/build
CMD python manage.py migrate && python manage.py runserver 0.0.0.0:5000
