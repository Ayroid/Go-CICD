# MULTI-STAGE BUILD

# BASE IMAGE - Used for building the application

FROM golang:1.22 AS base
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN go build -o main .

# DISTROLESS IMAGE - Used to copy and run the built executables
# reducing the size of the final docker image and enhancing security
# as the image only contains executable binaries and not the source code

FROM gcr.io/distroless/base
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD [ "./main" ]