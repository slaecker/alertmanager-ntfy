# Stage 1: Build the Go binary
FROM golang:1.19 AS builder

WORKDIR /app
COPY . .
RUN go mod download
WORKDIR /app/cmd/alertmanager-ntfy
RUN go mod tidy
RUN go build -o /app/alertmanager-ntfy .

# Stage 2: Minimal final image
FROM alpine:3.22
WORKDIR /app
COPY --from=builder /app/alertmanager-ntfy .
RUN apk add --no-cache ca-certificates

# Run the app
CMD ["./alertmanager-ntfy", "--configs", "/config/config.yml"]
