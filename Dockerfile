FROM prodacr001.azurecr.io/ros:jazzy-ros-base

LABEL maintainer="Akanksha"
LABEL description="ROS2 Jazzy CI/CD Demo"

# Install ROS2 example packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-examples-rclcpp-minimal-publisher \
    ros-jazzy-examples-rclcpp-minimal-subscriber \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -ms /bin/bash rosuser

USER rosuser
WORKDIR /home/rosuser

SHELL ["/bin/bash", "-c"]

# Source ROS automatically
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD ros2 topic list | grep minimal_publisher || exit 1


# Start ROS2 publisher and keep container alive
CMD ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && exec ros2 run examples_rclcpp_minimal_publisher publisher_member_function"]