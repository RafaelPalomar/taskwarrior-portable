# Use the official Debian 12 image as the base
FROM debian:12

# Label the container
LABEL maintainer="your-email@example.com"
LABEL description="Container with Taskwarrior, Timewarrior, and Taskwarrior-tui built from source"

# Install necessary packages for building taskwarrior-tui
# This includes git, build-essential (for basic build tools), and cargo (Rust package manager)
RUN apt-get update && \
    apt-get install -y git build-essential curl && \
    # Install Rust and Cargo using rustup
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . $HOME/.cargo/env && \
    # Install Taskwarrior and Timewarrior
    apt-get install -y taskwarrior timewarrior && \
    # Clone the taskwarrior-tui repository and build it
    git clone https://github.com/kdheepak/taskwarrior-tui.git && \
    cd taskwarrior-tui && \
    cargo build --release && \
    # Move the binary to a directory in PATH
    mv target/release/taskwarrior-tui /usr/local/bin/ && \
    # Clean up
    apt-get remove --purge -y git build-essential curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/.cargo /taskwarrior-tui


# Copy the taskwarrior-tui.desktop file to the container
COPY taskwarrior-tui.desktop /usr/local/share/applications/
