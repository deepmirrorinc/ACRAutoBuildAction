FROM mcr.microsoft.com/azure-cli as runtime

ADD entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ADD build.yaml /build.yaml
ADD build_latest.yaml /build_latest.yaml

ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
