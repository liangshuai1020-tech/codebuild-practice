# AWS CodeBuild 练习

使用现有 Angular Shop 示例，练习 AWS CodeBuild 构建、Docker 镜像打包、推送到 Amazon ECR，以及 ECS 部署交接。
学习重点是构建与交付流程；Angular 应用是练习载体。本仓库尚不代表端到端部署已验证成功。

## 文件导航

| 文件 / 目录 | 作用 |
| --- | --- |
| [buildspec.yml](buildspec.yml) | CodeBuild：安装依赖、构建前端、打包镜像、推送 ECR、生成 `imagedefinitions.json` |
| [Dockerfile](Dockerfile) | 当前使用 Apache httpd 提供 `dist/shop/` 静态文件 |
| [appspec.yml](appspec.yml) | 另一条 EC2 / CodeDeploy 练习配置，将文件复制到 `/var/www/html` |
| [src](src/) | Angular Shop 示例源代码 |
| [nginx/default.conf](nginx/default.conf) | 保留的 Nginx 配置；当前 Dockerfile 使用 httpd，未加载此配置 |
| [package.json](package.json) / [package-lock.json](package-lock.json) | 前端依赖声明与锁文件 |

## 当前构建流程

`CodeBuild → npm 构建 → Docker 镜像 → ECR → imagedefinitions.json`

`imagedefinitions.json` 为后续 ECS 部署阶段提供镜像信息，不会自行部署 ECS。
`appspec.yml` 属于单独的 EC2 / CodeDeploy 练习；当前 CodeBuild 只输出 `imagedefinitions.json`，不能直接作为它所需的部署包。

## 运行前需要补齐

- CodeBuild 项目、构建环境、Docker 所需配置、IAM Role 和 ECR 仓库需要在 AWS 中单独配置。
- ECR 地址和区域目前写在构建文件中；应改为构建环境变量，避免复制个人环境值。
- ECS 容器名需与生成文件中的 `web` 一致；任务定义、服务和部署阶段不在本仓库中。
- Angular 依赖为 7.x，构建文件指定 Node.js 16；版本均已结束官方支持，需单独安排兼容性检查和升级，不能视为生产环境方案。
- 当前 `npm run build` 执行 `ng build`，没有开启 production 配置；生产环境 API 地址的替换需单独核对。
- Dockerfile 使用 `httpd:latest`；镜像版本固定、单页应用回退路由和 `/api` 代理仍需验证。
- 示例代码的原始来源和许可待补充确认；本次整理未新增许可证或声称整个示例由本人原创。

本次文档整理未运行 AWS 构建、推送镜像或部署资源，也未验证当前云端服务状态。

## 后续学习记录

1. 记录一次构建的输入、输出和失败排查。
2. 将环境相关值改成变量，再验证 ECR / ECS 交接。
3. 区分 ECS 与 EC2 / CodeDeploy 两条练习路径。

## 原 Angular 示例使用说明

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 7.1.4.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).

版本状态参考：[Node.js 官方版本状态](https://nodejs.org/en/about/previous-releases)、[Angular 官方支持周期](https://angular.dev/reference/releases)。
