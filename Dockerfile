# From latest ruby version
FROM bearstech/ruby-dev:3.0

RUN apt-get update -y \
	&& apt-get upgrade -y

# Declare args
ARG REVISION
ARG RELEASE_TAG

# Add user
RUN useradd -ms /bin/bash rl

# Create src dir
RUN mkdir /opt/rl

# Workdir
WORKDIR /opt/rl

# Copy code
COPY . .

# Ownership
RUN chown -R rl:rl /opt/rl

# User
USER rl

# Download all the world
RUN bundle install

# image-spec annotations using labels
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.source="https://github.com/papey/rl"
LABEL org.opencontainers.image.revision=${GIT_COMMIT_SHA}
LABEL org.opencontainers.image.version=${RELEASE_TAG}
LABEL org.opencontainers.image.authors="Wilfried OLLIVIER"
LABEL org.opencontainers.image.title="rl"
LABEL org.opencontainers.image.description="rl runtime"
LABEL org.opencontainers.image.licences="ANTI-FASCIST LICENSE"

# setup default args
CMD ["--help"]

# setup entrypoint command
ENTRYPOINT ["bundle", "exec", "ruby", "bin/rl.rb"]
