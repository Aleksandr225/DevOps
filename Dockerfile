FROM ubuntu:22.04

RUN apt update && apt-get install -y \
    python3 \ 
    python3-pip

COPY . /app/
WORKDIR /app
RUN pip install Flask
EXPOSE 5000
CMD ["python3", "app.py"]
