FROM golang:1 as terragrunt
RUN go get github.com/gruntwork-io/terragrunt
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' github.com/gruntwork-io/terragrunt

FROM hashicorp/terraform:light
RUN apk add libc6-compat
COPY --from=terragrunt /go/bin/terragrunt /bin
ADD https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-arm64.tar.gz /
ADD https://storage.googleapis.com/kubernetes-release/release/v1.14.1/bin/linux/amd64/kubectl /bin/
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator /bin/
RUN chmod 0755 /bin/aws-iam-authenticator && \
    chmod 0755 /bin/kubectl && \
    tar --strip=1 -zxf helm-v2.13.1-linux-arm64.tar.gz -C /bin/ linux-arm64/helm linux-arm64/tiller && \
    rm /helm-v2.13.1-linux-arm64.tar.gz && \
    chmod 0755 /bin/helm && \
    chmod 0755 /bin/tiller
ENTRYPOINT ["/bin/terragrunt"]
