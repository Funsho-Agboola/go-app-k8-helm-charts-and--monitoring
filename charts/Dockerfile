FROM golang:1.12-alpine AS build

RUN apk add --no-cache git
WORKDIR /src

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# Unit tests
RUN CGO_ENABLED=0 go test -v

# Build the Go app
RUN go build -o ./out/go-app .
FROM alpine:3.9 
RUN apk add ca-certificates
COPY --from=build /src/out/go-app /app/go-app
EXPOSE 8080

# Run the binary program produced by `go install`
CMD ["/app/go-app"]