FROM python:3.10-bullseye

RUN apt-get update && \
    apt-get install -y default-jdk && \
    apt-get clean

RUN pip install --no-cache-dir pyspark==3.5.1

WORKDIR /app

COPY . .

CMD ["python", "employee_rdd.py"]