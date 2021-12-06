FROM python:3.6
MAINTAINER ashish@gmail.com 
EXPOSE 5000
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
CMD python run.py