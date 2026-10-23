# ETAPA 1: Compilación (¡Actualizado a Go 1.22! 🎉)
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

# Copiar archivos de módulos de Go
COPY go.mod ./
RUN go mod download

# Copiar el código y la carpeta 'dist' de React
COPY . .

# Compilar el binario removiendo peso innecesario
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o yotzen-services .

# ETAPA 2: Producción
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Traemos ÚNICAMENTE el archivo ejecutable compilado en la Etapa 1
COPY --from=builder /app/yotzen-services .

EXPOSE 8080

CMD ["./yotzen-services"]
