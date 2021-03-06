FROM debian:buster

# Defines the Factorio Version
ARG VERSION=stable

# Update Repository Information
RUN apt-get update --quiet

# Install curl and xz-utils (For Downloading & Decompressing the Factorio Archive)
RUN apt-get install curl xz-utils python3 --yes --quiet

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
RUN curl -L https://factorio.com/get-download/${VERSION}/headless/linux64 -o download.tar.xz

# Extract the Factorio Archive to /opt/factorio
# We use strip-components=1, because the archive contains a "factorio" directory, which contains everything we need.
# As we've already created a directory where we want this to go, we do not double directories.
# Eg. /opt/factorio/factorio - Alternatively we could decompress this directly into /opt, avoiding the second directory.
# But then we would need to do more work with chown to get all the permissions right, this seems easier.
RUN tar -xf download.tar.xz -C /opt/factorio --strip-components=1

# Clean Up the Download
RUN rm download.tar.xz

# Create a Save – Then Delete It
# We do this to make the server generate a number of files and directories for us, which are generated on start.
RUN /opt/factorio/bin/x64/factorio --create /opt/factorio/saves/default.zip
RUN rm /opt/factorio/saves/default.zip

# Create Symbolic Links to Configs, Saves, and Mods
RUN rm -rf /opt/factorio/config
RUN rm -rf /opt/factorio/saves
RUN rm -rf /opt/factorio/mods
RUN ln -sfFT /mnt/factorio/config /opt/factorio/config
RUN ln -sfFT /mnt/factorio/saves /opt/factorio/saves
RUN ln -sfFT /mnt/factorio/mods /opt/factorio/mods

# Copy in the Start Script
COPY --chown=factorio:factorio entrypoint.py .

# Make the Start Script Runnable
RUN chmod u+x entrypoint.py

# Start the Server
ENTRYPOINT [ "./entrypoint.py" ]

# the Factorio Server Port
EXPOSE 34197/udp
