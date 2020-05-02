FROM debian:buster

# Update Repository Information
RUN apt-get update --quiet

# Install curl and xz-utils (For Decompressing the Factorio Archive)
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
# We use strip-components=1, because the archive contains a "factorio" directory, which contains everything we need.
# As we've already created a directory where we want this to go, we do not double directories.
# Eg. /opt/factorio/factorio - Alternatively we could decompress this directly into /opt, avoiding the second directory.
# But then we would need to do more work with chown to get all the permissions right, this seems easier.
RUN tar -xf download.tar.xz -C /opt/factorio --strip-components=1

# Clean up the download
RUN rm download.tar.xz

# Move to the /opt/factorio Directory
WORKDIR /opt/factorio

# Create a Save
RUN /opt/factorio/bin/x64/factorio --create ./saves/default.zip
