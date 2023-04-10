FROM rocker/tidyverse:latest
RUN R -e 'install.packages("shiny")'
COPY app.R /app.R
EXPOSE 3838
CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'
