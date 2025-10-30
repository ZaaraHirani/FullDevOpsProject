FROM python:3.9-slim
WORKDIR /app
COPY app.py /app
RUN pip install Flask
# We will use this to "tag" our image
ARG BUILD_NUMBER
ENV BUILD_NUMBER=${BUILD_NUMBER}
CMD ["python", "app.py"]
