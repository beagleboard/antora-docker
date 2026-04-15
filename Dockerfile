FROM alpine:latest

RUN apk --no-cache add nodejs npm git ruby-dev graphicsmagick-dev pkgconfig build-base

WORKDIR /antora

RUN npm install -g antora @antora/lunr-extension @antora/pdf-extension github:beagleboard/antora-ui-beagle
RUN gem install --clear-sources asciidoctor-pdf rouge prawn-gmagick

ENTRYPOINT [ \
        "antora", \
        "--attribute", \
        "pdf-theme=/usr/local/lib/node_modules/@beagleboard/antora-ui/pdf-theme.yml", \
        "--stacktrace", \
        "--log-level", \
        "all"]
