# Base image
FROM node:14-alpine AS builder

# Set working directory
WORKDIR /frontend

# Copy package.json and package-lock.json
COPY /frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Build the React app
RUN npm run build

# Production image
FROM python:3.9-slim-buster AS production

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /backend

# Install dependencies
RUN apt-get update \
    && apt-get -y install netcat gcc \
    && pip install --upgrade pip \

# Copy requirements.txt
COPY /backend/requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy React build files
COPY --from=builder /frontend/build /frontend/builder/build

# Copy Django app code
COPY . .

# Collect static files
RUN python manage.py collectstatic --no-input

# Expose port 8000
EXPOSE 8000

# Start Gunicorn
CMD gunicorn backend.wsgi:application --bind 0.0.0.0:8000
