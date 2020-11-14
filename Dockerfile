## 1. Build Container ##
FROM alpine:3.12.1 AS build

# 빌드를 위한 패키지 설치
RUN apk add --update npm yarn 

RUN mkdir -p /src

# 의존성 패키지리스트 복사
COPY package.json yarn.lock /src/
WORKDIR /src

# 의존성 패키지 설치 
RUN yarn install

# Frontend 빌드
COPY . /src
RUN yarn run build

## 2. Runtime Container ##
FROM alpine:3.12.1 

# 필요 패키지 설치 
RUN apk add --update npm && \
    npm install -g serve

# 빌드 컨테이너에서 빌드 완료된 frontend 복사
WORKDIR /app
COPY --from=build /src/dist /app/dist

EXPOSE 5000

CMD ["serve", "-s", "dist"]
