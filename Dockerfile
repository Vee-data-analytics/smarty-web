FROM node:18-alpine AS builder
WORKDIR /frontend
COPY /frontend/package.json .
COPY /frontend/package-lock.json .
RUN npm install
COPY . .
CMD npm install && npm audit fix && npm run start


FROM python:3.9-slim-buster
WORKDIR /backend
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
COPY backend/requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD python manage.py migrate && python manage.py runserver 0.0.0.0:8000
