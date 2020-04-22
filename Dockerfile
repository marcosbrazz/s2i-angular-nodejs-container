# angular-nodeproxy-centos7
FROM centos/s2i-base-centos7:1

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Marcos Henrique Braz <mhbraz@br.ibm.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV ANGULAR_NODEPROXY_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Angular applications, serve and proxy it by nodejs. Uses Angular CLI 9" \
      io.k8s.display-name="Angular Node Proxy 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,angular,nodejs."

# TODO: Install required packages here:
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash - && \
    yum install -y nodejs && \
    echo "n" | npm install -g @angular/cli@9.x.x && \
    yum clean all -y


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
