ARG BASE_IMAGE_TAG
FROM getty708/copybara:${BASE_IMAGE_TAG}

# Add ssh config 
RUN mkdir /root/.ssh \
    && chmod 700 /root/.ssh
COPY config /root/.ssh/config
