# Build frontend
FROM node:14-alpine as frontend

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ .

RUN npm run build

# Build backend
FROM python:3.9-alpine as backend

WORKDIR /app/backend

COPY backend/requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

# Copy frontend build to backend static files directory
COPY --from=frontend /app/frontend/build /app/backend/staticfiles

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
