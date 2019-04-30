FROM golang:1 as terragrunt
RUN go get github.com/gruntwork-io/terragrunt
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' github.com/gruntwork-io/terragrunt

FROM hashicorp/terraform:light
RUN apk add libc6-compat
COPY --from=terragrunt /go/bin/terragrunt /bin
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator /bin/
ENTRYPOINT ["/bin/terragrunt"]
