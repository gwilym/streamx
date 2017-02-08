FROM confluentinc/cp-kafka:3.1.2

MAINTAINER pseluka@qubole.com

ADD . $STREAMX_SRC_DIR

ENV BUILD_PACKAGES="maven"
ENV DEPENDENCY_PACKAGES="vim"
ENV STREAMX_DIR /usr/local/streamx
ENV STREAMX_SRC_DIR /usr/local/streamx-src

RUN apt-get clean && \
	apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y $DEPENDENCY_PACKAGES $BUILD_PACKAGES && \
	mkdir -p $STREAMX_DIR $STREAMX_SRC_DIR $STREAMX_DIR/config && \
	cd $STREAMX_SRC_DIR && \
	mvn -DskipTests package && \
	cp -r target/streamx-0.1.0-SNAPSHOT-development/share/java/streamx/* $STREAMX_DIR && \
	cp -r config/* $STREAMX_DIR/config && \
	cp -r docker/* $STREAMX_DIR && \
	chmod 777 $STREAMX_DIR/entry && \
	apt-get purge -y $BUILD_PACKAGES && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 8083

ENV CLASSPATH=$CLASSPATH:$STREAMX_DIR/*

CMD ["bash","$STREAMX_DIR/entry"]
