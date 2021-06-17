FROM alpine:latest as build
RUN apk add R R-dev musl-dev g++
RUN Rscript \
-e 'install.packages(c("dplyr", "tidyr", "stringr", "lubridate", "glue", "readr", "httr"), repos="https://ftp.osuosl.org/pub/cran/")'

FROM alpine:latest as tidy
RUN apk add R && echo ""
COPY --from=build /usr/lib/R/library/. /usr/lib/R/library
ENTRYPOINT [ "R" "--no-save" ]