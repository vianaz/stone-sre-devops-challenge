# syntax=docker/dockerfile:1

ARG NODE_VERSION=20.11.1

# Setup the base image
FROM node:${NODE_VERSION}-alpine AS alpine

# Setup pnpm
FROM alpine AS base
RUN corepack enable
RUN pnpm config set store-dir ~/.pnpm-store

# Setup all the dependencies to build the project
FROM base AS dev-deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=~/.pnpm-store pnpm install --frozen-lockfile

# Setup only production dependencies
FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=~/.pnpm-store pnpm install --prod --frozen-lockfile

# Build the project
FROM dev-deps AS builder
ENV NODE_ENV=production
COPY . .
RUN pnpm build

# Run layer
FROM deps AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 api
USER api

COPY --from=builder /app/build .

CMD [ "pnpm", "start" ]
