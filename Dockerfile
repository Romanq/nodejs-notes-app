# Using multistage to download dependencies from package.json file
# Look's fine with speed advantage if there's no dep changes

FROM node:18.19.0-buster-slim as base

WORKDIR /opt/temp_install

COPY package.json /opt/temp_install

RUN npm install

# Final image is 60 Mb compressed.
# Reuslt size around 250-300Mb, that 5 times better than original image size with node:18
FROM node:18.19.0-buster-slim as final

COPY --from=base /opt/temp_install/node_modules /opt/frontend/

COPY package.json /opt/frontend/package.json

COPY ./src /opt/frontend

WORKDIR /opt/frontend/

# Assign environment variable for port defenition or use default 4000
EXPOSE ${PORT:-4000}

CMD [ "node", "index.js" ]

# Result images 278 Mb