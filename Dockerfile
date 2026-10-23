# ETAPA 1: Compilación
FROM golang:1.21-alpine AS builder
RUN apk add --no-cache git
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .

# 👇 AQUÍ: Cambiamos el nombre del archivo de salida a yotzen-services
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o yotzen-services .

# ETAPA 2: Producción
FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app

# 👇 AQUÍ: Copiamos tu archivo con su nombre real
COPY --from=builder /app/yotzen-services .

EXPOSE 8080

# 👇 AQUÍ: Ejecutamos tu proyecto con su nombre real
CMD ["./yotzen-services"]
