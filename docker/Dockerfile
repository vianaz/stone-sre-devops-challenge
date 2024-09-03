# syntax=docker/dockerfile:1

ARG NODE_VERSION=20.11.1
ARG PNPM_VERSION=9.1.4


# 1. Alpine image
FROM node:${NODE_VERSION}-alpine AS alpine
RUN apk update
RUN apk add --no-cache libc6-compat

# Setup pnpm
FROM alpine AS base
RUN corepack enable
RUN npm install turbo --global
RUN pnpm config set store-dir ~/.pnpm-store

# 2. Build the project
FROM base AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

# # First install the dependencies (as they change less often)
RUN --mount=type=cache,id=pnpm,target=~/.pnpm-store pnpm install --frozen-lockfile

COPY . .

RUN pnpm build

# 3. Prune the dependencies and install only production dependencies
FROM base AS pruner

WORKDIR /app

COPY --from=builder /app/build .

RUN --mount=type=cache,id=pnpm,target=~/.pnpm-store pnpm install --prod --frozen-lockfile

# # 4. Final image - runner stage to run the application
FROM pruner AS runner

WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 api
USER api

COPY --from=pruner /app .

CMD ["pnpm", "start"]
