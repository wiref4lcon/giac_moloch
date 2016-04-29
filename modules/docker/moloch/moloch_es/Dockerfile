FROM centos:7
MAINTAINER Giac-FPC

# Setup yum
RUN yum -y install epel-release && yum -y install net-tools vim wget curl pcre pcre-devel pkgconfig flex bison gcc-c++ zlib-devel e2fsprogs-devel file-devel make gettext libuuid-devel perl-JSON bzip2-libs bzip2-devel perl-libwww-perl libpng-devel xz libffi-devel java-1.7.0-openjdk perl-JSON supervisor

# Setup libraries, binaries, config files
ADD moloch.tgz /data/
ADD supervisord.conf /etc/supervisord.d/supervisord.conf

# Start Moloch
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.d/supervisord.conf"]
