#
# Copyright (c) 2022 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file builds a simple image containing Kafka and Debezium.

# Use RHEL 8 as base:
FROM registry.access.redhat.com/ubi8/ubi:8.5-214

# Install the required packages:
RUN \
    dnf -y install \
    curl \
    java-11-openjdk-headless \
    openssl \
    tar \
    && \
    dnf clean all

# Install Kafka:
RUN \
    curl -Lo /tmp/tarball https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz && \
    echo a82728166bbccf406009747a25e1fe52dbcb4d575e4a7a8616429b5818cd02d1 /tmp/tarball | sha256sum -c && \
    mkdir -p /opt/kafka && \
    tar -C /opt/kafka -x --strip-components 1 --exclude 'site-docs' --exclude 'bin/windows' -f /tmp/tarball && \
    rm /tmp/tarball

# Install Debezium PostgreSQL plugin:
RUN \
    curl -Lo /tmp/tarball https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/1.7.0.Final/debezium-connector-postgres-1.7.0.Final-plugin.tar.gz && \
    echo 7abb92c18b92c0cda9e9063ba64fad27f3ef7f13b87c7a7a37ba2217913723f9 /tmp/tarball | sha256sum -c && \
    mkdir -p /opt/kafka/connect && \
    tar -C /opt/kafka/connect -x -f /tmp/tarball && \
    rm /tmp/tarball
