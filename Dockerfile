FROM debian:buster

# Update Repository Information
RUN apt-get update --quiet

# Install curl
RUN apt-get install curl --yes --quiet

# Create Factorio Group
RUN groupadd factorio

# Create Factorio User
RUN useradd --create-home factorio -g factorio

# Switch to the Factorio User
USER factorio

# Move to the Factorio Home Directory
WORKDIR /home/factorio

# Download Factorio Server Binary
RUN curl -L https://factorio.com/get-download/stable/headless/linux64 -o download.tar.gz
