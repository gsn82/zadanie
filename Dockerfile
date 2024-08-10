# Указываем ARG переменные
ARG GCC_VERSION=12-slim
ARG GOLANG_VERSION=latest
ARG ALPINE_VERSION=12-slim

# Создаем контейнер для сборки приложения на Go
FROM golang:${GOLANG_VERSION} AS builder2

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \ 
    wget 

ARG GO_SOURCE_URL=https://raw.githubusercontent.com/gsn82/zadanie/main/main.go

#WORKDIR /app_go
# Скачиваем файл main.go
RUN wget $GO_SOURCE_URL -O /main.go 
# Теперь компилируем приложение на Go
RUN go build -o /app_go /main.go 


# Создаем контейнер для сборки приложения на C/C++
FROM debian:${GCC_VERSION} AS builder1

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \ 
    wget \
    g++ \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV CPP_SOURCE_URL=https://raw.githubusercontent.com/gsn82/zadanie/main/main.cpp

#WORKDIR /app_cpp
RUN wget $CPP_SOURCE_URL -O /main.cpp 
RUN g++ /main.cpp -o /app_cpp  

# Создаем финальный контейнер, куда поместим оба собранных приложения 
FROM debian:${ALPINE_VERSION}  

#WORKDIR /apps  

COPY --from=builder1 /app_cpp ./  
COPY --from=builder2 /app_go ./  

# Убедитесь, что файл имеет права на выполнение
RUN chmod +x app_cpp app_go 

# Определяем переменную для выбора приложения по умолчанию
ARG DEFAULT_APP=cpp

# Определяем команду по умолчанию для запуска одного из двух приложений
CMD ["sh", "-c", "if [ \"$DEFAULT_APP\" = \"go\" ]; then exec ./app_go; else exec ./app_cpp; fi"]
