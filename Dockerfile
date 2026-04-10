FROM alpine:latest

ENV UI_BUNDLE_URL=https://github.com/beagleboard/antora-ui-beagle/releases/download/continuous-release/ui-bundle.zip

RUN apk --no-cache add nodejs npm git ruby

WORKDIR /antora

RUN npm install -g antora @antora/lunr-extension @antora/pdf-extension github:beagleboard/antora-ui-beagle
RUN gem install --clear-sources asciidoctor-pdf rouge

ADD $UI_BUNDLE_URL /antora-ui-bundle.zip

ENTRYPOINT ["antora", "--attribute", "pdf-theme=/usr/local/lib/node_modules/@beagleboard/antora-ui/pdf-theme.yml", "--ui-bundle-url", "/antora-ui-bundle.zip"]
