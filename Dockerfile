# ================ #
#    Base Stage    #
# ================ #
FROM node:18-buster-slim as base
WORKDIR /opt/app
ENV CI=true

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends build-essential python3 dumb-init && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=node:node package-lock.json .
COPY --chown=node:node package.json .
COPY --chown=node:node tsconfig.base.json .

ENTRYPOINT ["dumb-init", "--"]

# ================ #
#   Builder Stage  #
# ================ #
FROM base as build
RUN npm install
COPY . /opt/app
RUN npm run build

# ==================== #
#   Production Stage   #
# ==================== #
FROM base as production
ENV NODE_ENV="production"

COPY --from=build /opt/app/dist /opt/app/dist
COPY --from=build /opt/app/node_modules /opt/app/node_modules
COPY --from=build /opt/app/package.json /opt/app/package.json

RUN chown node:node /opt/app/
USER node
CMD ["npm", "run", "start"]
