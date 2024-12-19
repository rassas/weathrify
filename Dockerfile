# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION-slim

# Rails app directory
WORKDIR /rails

# Install runtime base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ENV BUNDLE_PATH="/home/weathrify/vendor/bundle"

# Install packages needed to build gems and Node/Yarn
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config gnupg && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install Node.js and Yarn
ENV NODE_MAJOR=20 \
    COREPACK_HOME=/tmp/corepack
COPY package.json yarn.lock ./
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
    | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update -qq && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && apt-get clean && \
    corepack enable && \
    corepack use yarn@* && yarn install && yarn cache clean && \
    yarn install

# Copy the entire app
COPY . .

# Precompile Bootsnap for faster boot
RUN bundle exec bootsnap precompile app/ lib/
