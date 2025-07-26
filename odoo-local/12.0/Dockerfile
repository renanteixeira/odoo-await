ARG odoo_version=12.0

###########################################################################
# build stage, install Odoo

FROM ghcr.io/acsone/odoo-bedrock:${odoo_version}-py36-latest AS build

ARG odoo_version

RUN sed -i 's|apt.postgresql.org|apt-archive.postgresql.org|g' /etc/apt/sources.list.d/*pgdg*.list || true

# Install build dependencies
RUN apt -yq update \
&& apt -yq install --no-install-recommends \
   curl \
   libpq-dev \
   libldap2-dev \
   libsasl2-dev \
   build-essential \
   python3.6-dev \
   libffi-dev \
   libcairo2-dev \
   libcairo2 \
   pkg-config \
   libxml2-dev libxslt1-dev \
&& rm -rf /var/lib/apt/lists/* 

RUN pip3 install --force-reinstall pip setuptools==57.5.0

ADD https://raw.githubusercontent.com/odoo/odoo/${odoo_version}/requirements.txt /odoo/src/odoo/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r /odoo/src/odoo/requirements.txt

ADD https://api.github.com/repos/odoo/odoo/git/refs/heads/${odoo_version} /tmp/odoo_version.json
RUN curl -sSL https://github.com/odoo/odoo/tarball/${odoo_version} | tar -C /odoo/src/odoo --strip-components=1 -xz
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -e /odoo/src/odoo

RUN mkdir -p /odoo/src/design-themes /odoo/src/extra_addons
RUN curl -sSL https://github.com/odoo/design-themes/tarball/${odoo_version} | tar -C /odoo/src/design-themes --strip-components=1 -xz

###########################################################################
# runtime stage

FROM ghcr.io/acsone/odoo-bedrock:${odoo_version}-py36-latest

RUN sed -i 's|apt.postgresql.org|apt-archive.postgresql.org|g' /etc/apt/sources.list.d/*pgdg*.list || true

# Install runtime system dependencies
RUN apt -yq update \
&& apt -yq install \
   postgresql-client \
   git wget \
   libxmlsec1-dev \
   pkg-config \
   python3.6-dev \
   python3-pip \
   libldap2-dev \
   libpq-dev \
   libsasl2-dev swig \
   libxml2-dev libxslt1-dev \
&& rm -rf /var/lib/apt/lists/*

# Copy venv from build stage to runtime stage
COPY --from=build /odoo /odoo
RUN mkdir -p /odoo/src/enterprise
ENV ADDONS_PATH=/odoo/src/odoo/addons,/odoo/src/odoo/odoo/addons,/odoo/src/design-themes,/odoo/src/enterprise

RUN pip3 install --force-reinstall pip setuptools==57.5.0
