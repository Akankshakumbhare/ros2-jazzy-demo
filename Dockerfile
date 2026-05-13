FROM ros:jazzy-ros-base

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

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Healthcheck
HEALTHCHECK CMD ros2 topic list || exit 1

# Start publisher node
CMD source /opt/ros/jazzy/setup.bash && \
    ros2 run examples_rclcpp_minimal_publisher publisher_member_function