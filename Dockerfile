FROM debian:buster

# Update Repository Information
RUN apt-get update --quiet

# Install curl
RUN apt-get install curl --yes --quiet
# Download Factorio Server Binary
RUN curl -L https://factorio.com/get-download/stable/headless/linux64 -o download.tar.gz
