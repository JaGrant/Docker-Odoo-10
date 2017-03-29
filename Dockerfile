FROM debian:jessie

# Install Vim
RUN apt-get update \
	&& apt-get -y install vim \
	&& apt-get -y install sudo \
	&& apt-get -y install bash \
	&& apt-get -y install wget \
	&& apt-get -y install git \
	&& apt-get -y install python2.7 \
	&& apt-get -y install python-pip \
	&& apt-get -y install postgresql \
	&& apt-get -y install nano \
	&& apt-get -y install python-virtualenv \
	&& apt-get -y install fontconfig \
	&& apt-get -y install libfontconfig1 \
	&& apt-get -y install libfreetype6 \
	&& apt-get -y install libpng12-0 \
	&& apt-get -y install libjpeg62-turbo \
	&& apt-get -y install libx11-6 \
	&& apt-get -y install libxext6 \
	&& apt-get -y install libxrender1 \
	&& apt-get -y install xfonts-base \
	&& apt-get -y install xfonts-75dpi


# Install Wkhtmltopdf - A runtime dependency of Odoo used to produce PDF reports
RUN wget http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
RUN dpkg -i wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
RUN apt-get -y install gcc python2.7-dev libxml2-dev \
	libxslt1-dev libevent-dev libsasl2-dev libldap2-dev libpq-dev \
	libpng12-dev libjpeg-dev

# Configure PostgreSQL
ADD postgres.sh /
RUN chmod 0644 /postgres.sh
RUN chmod a+x /postgres.sh
RUN /postgres.sh


#Configure Git
RUN git config --global user.name "Jason Grant"
RUN git config --global user.email jaygrant.it@gmail.com

# Clone Odoo code base:
RUN git clone -b 10.0 --depth=1 --single-branch https://github.com/odoo/odoo.git ~/odoo


# Create python virtual enviroment
RUN virtualenv ~/odoo-10.0
RUN . ~/odoo-10.0/bin/activate


# Install Python Dependencies for Odoo
RUN pip install -r ~/odoo/requirements.txt

# Create and start Odoo Instance
#RUN createdb odoo-test

#EXPOSE 8069 5432
CMD ["python odoo.py -d odoo-test --addons-path=addons --dbfilter=odoo-test$"]




 
