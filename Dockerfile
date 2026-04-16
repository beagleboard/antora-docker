FROM alpine:latest AS builder

RUN apk --no-cache add nodejs npm git ruby-dev graphicsmagick-dev pkgconfig build-base

RUN npm install -g --omit=dev --prefer-dedupe antora @antora/lunr-extension @antora/pdf-extension github:beagleboard/antora-ui-beagle
RUN gem install --clear-sources --no-document asciidoctor-pdf rouge prawn-gmagick rghost

# Cleanup
RUN npm cache clean --force \
 && find /usr/local/lib/node_modules -name "test" -type d -prune -exec rm -rf '{}' + \
 && find /usr/local/lib/node_modules -name "*.md" -delete
RUN rm -rf /usr/lib/ruby/gems/*/cache \
        /usr/lib/ruby/gems/*/build_info \
        /usr/lib/ruby/gems/*/doc \
        /usr/lib/ruby/gems/*/plugins

FROM alpine:latest

RUN apk --no-cache add nodejs ruby graphicsmagick ghostscript

COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/lib/ruby/gems /usr/lib/ruby/gems
COPY --from=builder /usr/bin/asciidoctor-pdf /usr/bin/

WORKDIR /antora

ENTRYPOINT [ \
        "antora", \
        "--attribute", \
        "pdf-theme=/usr/local/lib/node_modules/@beagleboard/antora-ui/pdf-theme.yml", \
        "--stacktrace", \
        "--log-level", \
        "all"]
