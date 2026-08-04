# it-tools 镜像 —— 构建期产出 dist/，运行期只是一个 nginx 发静态文件。
#
# ⚠️ 两个 FROM 都**显式钉版本**，别改回浮动 tag（2026-08-05 的两次教训）：
#
#   1. 构建期原来是 `node:lts-alpine`。lts 一直在漂：本项目 .nvmrc 写的是 18.18.2，
#      而 2026-08 的 node:lts-alpine 已经是 v24 —— 也就是说任何一次重建都在悄悄
#      跨好几个 node 大版本赌构建不炸。钉死后重建结果可复现。
#   2. 运行期原来是 `nginx:stable-alpine`。它自己会跟着 nginx stable 走，本来没问题，
#      真正的问题是这个镜像**几个月没重建过**：Trivy 在 oracle-k3s 上报出 3 条 Critical
#      （libssl3/libcrypto3 3.5.5-r0 的 CVE-2026-31789 + nginx 1.28.2-r1 的
#      CVE-2026-42945 任意代码执行, CVSS 8.1），而同期 stable-alpine 早已是
#      nginx 1.30.4-r1 + openssl 3.5.7-r0，重建即清零。
#
# 最终镜像里只有 dist/ + nginx.conf（无 node_modules），所以 Trivy 的发现**全部**来自
# 运行期 base —— 换言之这个镜像的 CVE 状况完全等于 nginx tag 的新鲜度。
# base 出 CVE 时重跑 .github/workflows/docker.yml（workflow_dispatch）即可；
# 该 workflow 另配了每周定时重建，避免再次腐化。

# build stage
ARG NODE_VERSION=22-alpine
FROM node:${NODE_VERSION} AS build-stage
# Set environment variables for non-interactive npm installs
ENV NPM_CONFIG_LOGLEVEL=warn
ENV CI=true
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
# ⚠️ 别改回 `npm install -g pnpm`：那会装当时的最新 pnpm(2026-08 已是 v10)，
# 而本项目 package.json 里 packageManager 钉的是 pnpm@9.11.0。实测 v10 会以
# 「Cannot verify the identity of the @pnpm/exe.linux-arm64 native binary:
#  it is missing from pnpm-lock.yaml」直接失败。
# corepack 会读 packageManager 字段取那个确切版本 —— 版本号只在 package.json 声明一次
# （CI 的 .github/workflows/docker.yml 也是用 corepack，口径一致）。
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable && pnpm i --frozen-lockfile
COPY . .
RUN pnpm build

# production stage
# 1.30 = 当前 nginx stable 线（实测 nginx-1.30.4-r1 / openssl 3.5.7-r0）。
FROM nginx:1.30-alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
