FROM debian:buster

# Defines the Factorio Version
ARG version=stable

# Update Repository Information
RUN apt-get update --quiet

# Install curl and xz-utils (For Downloading & Decompressing the Factorio Archive)
RUN apt-get install curl xz-utils --yes --quiet

# Create Factorio Group
RUN groupadd factorio -g 1000

# Create Factorio User
RUN useradd --create-home factorio -g factorio -u 1000

# Create a Factorio Directory in /opt and /mnt
RUN mkdir /opt/factorio
RUN mkdir /mnt/factorio

# Set Ownership of /opt/factorio and /mnt/factorio to Factorio
RUN chown factorio:factorio /opt/factorio
RUN chown factorio:factorio /mnt/factorio

# Switch to the Factorio User
USER factorio

# Move to the Factorio Home Directory
WORKDIR /home/factorio

# Download Factorio Server Archive
RUN curl -L https://factorio.com/get-download/${version}/headless/linux64 -o download.tar.xz

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

# Create a Save - Then Delete it
# We do this to make the server generate a number of files and directories for us, which are generated on start.
RUN bin/x64/factorio --create saves/default.zip
RUN rm saves/default.zip

# Create Symbolic Links to Configuration Files
RUN ln -s /mnt/factorio/config/map-gen-settings.json config/map-gen-settings.json
RUN ln -s /mnt/factorio/config/map-settings.json config/map-settings.json
RUN ln -s /mnt/factorio/config/server-settings.json config/server-settings.json
RUN ln -s /mnt/factorio/config/server-whitelist.json config/server-whitelist.json
RUN ln -s /mnt/factorio/config/server-banlist.json config/server-banlist.json
RUN ln -s /mnt/factorio/config/server-adminlist.json config/server-adminlist.json

# Start the Server
#ENTRYPOINT [ "/opt/factorio/bin/x64/factorio", "--start-server-load-latest" ]

# The Factorio Server Port
EXPOSE 34197/udp
