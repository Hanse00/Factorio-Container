FROM debian:buster

# Update Repository Information
RUN apt-get update --quiet

# Install curl
RUN apt-get install curl xz-utils --yes --quiet

# Create Factorio Group
RUN groupadd factorio

# Create Factorio User
RUN useradd --create-home factorio -g factorio

# Create a Factorio Directory in /opt
RUN mkdir /opt/factorio

# Set Ownership of /opt/factorio to Factorio
RUN chown factorio:factorio /opt/factorio

# Switch to the Factorio User
USER factorio

# Move to the Factorio Home Directory
WORKDIR /home/factorio

# Download Factorio Server Archive
RUN curl -L https://factorio.com/get-download/stable/headless/linux64 -o download.tar.xz

# Extract the Factorio Archive to /opt/factorio
RUN tar -xf download.tar.xz -C /opt/factorio --strip-components=1
