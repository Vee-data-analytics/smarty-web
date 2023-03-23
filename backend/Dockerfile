FROM python:3.9

WORKDIR /frontend

COPY requirements.txt /frontend/

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . /frontend/

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
