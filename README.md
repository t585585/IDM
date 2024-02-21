# Дипломная работа профессии "DevOps-инженер"
___
## Содержание
  * [Создание облачной инфраструктуры](#1-создание-облачной-инфраструктуры)
  * [Создание Kubernetes кластера](#2-создание-kubernetes-кластера)
  * [Создание тестового приложения](#3-создание-тестового-приложения)
  * [Подготовка системы мониторинга и деплой приложения](#4-подготовка-системы-мониторинга-и-деплой-приложения)
  * [Установка и настройка CI/CD](#5-установка-и-настройка-cicd)
___

### 1. Создание облачной инфраструктуры
___
- Подготовлена облачная инфраструктура в ЯО при помощи [Terraform](https://www.terraform.io/).  [![.](img/img_00.png)](img/img_11.jpg)
- Создан сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой. [![.](img/img_00.png)](img/img_12.jpg)
- Подготовлен [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform - S3 bucket в созданном ЯО аккаунте при помощи TF. [![.](img/img_00.png)](img/img_13.jpg)
- Созданы VPC с подсетями в разных зонах доступности. ___ЯО выводит зону ru-central1-c из эксплуатации___. [![.](img/img_00.png)](img/img_14.jpg) 
- Выполнены команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.

Результат:

- Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
- Файлы Terraform расположены в [репозитории. ![.](img/img_03.png)](terraform_files) 
---
### 2. Создание Kubernetes кластера
___
- Создан `Kubernetes` кластер на базе предварительно созданной инфраструктуры.
- Обеспечен доступ к ресурсам из Интернета.

Создание кластера выполнялось при помощи 'Kubespray'.

- При помощи Terraform подготовлены 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальных машины выбирался с учётом требований к стоимости и производительности.  
- Подготовлены `ansible` конфигурации `Kubespray`
- Задеплоен Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов всегда можно создать их при помощи Terraform.
  
Результат:

- Работоспособный Kubernetes кластер.
- В файле `~/.kube/config` на локальной машине находятся данные для доступа к кластеру.
- Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.
```bash
kubectl get nodes,pods --all-namespaces
NAME           STATUS   ROLES           AGE   VERSION
node/control   Ready    control-plane   30h   v1.29.1
node/node1     Ready    <none>          30h   v1.29.1
node/node2     Ready    <none>          30h   v1.29.1

NAMESPACE     NAME                                                         READY   STATUS    RESTARTS        AGE
kube-system   pod/calico-kube-controllers-648dffd99-4fnm9                  1/1     Running   12 (104m ago)   30h
kube-system   pod/calico-node-5xvkt                                        1/1     Running   3 (105m ago)    30h
kube-system   pod/calico-node-6gj7q                                        1/1     Running   1 (7h12m ago)   30h
kube-system   pod/calico-node-nvrq2                                        1/1     Running   1 (7h10m ago)   30h
kube-system   pod/coredns-69db55dd76-86tct                                 1/1     Running   1 (7h10m ago)   30h
kube-system   pod/coredns-69db55dd76-9xpgb                                 1/1     Running   3 (105m ago)    30h
kube-system   pod/dns-autoscaler-6f4b597d8c-zrp6d                          1/1     Running   3 (105m ago)    30h
kube-system   pod/kube-apiserver-control                                   1/1     Running   4 (105m ago)    30h
kube-system   pod/kube-controller-manager-control                          1/1     Running   7 (105m ago)    30h
kube-system   pod/kube-proxy-6bbnq                                         1/1     Running   1 (7h10m ago)   30h
kube-system   pod/kube-proxy-f7wqp                                         1/1     Running   1 (7h12m ago)   30h
kube-system   pod/kube-proxy-sm8sg                                         1/1     Running   3 (105m ago)    30h
kube-system   pod/kube-scheduler-control                                   1/1     Running   6 (105m ago)    30h
kube-system   pod/nginx-proxy-node1                                        1/1     Running   1 (7h12m ago)   30h
kube-system   pod/nginx-proxy-node2                                        1/1     Running   1 (7h10m ago)   30h
kube-system   pod/nodelocaldns-4l5bm                                       1/1     Running   2 (7h9m ago)    30h
kube-system   pod/nodelocaldns-85f28                                       1/1     Running   2 (7h9m ago)    30h
kube-system   pod/nodelocaldns-zwfsv                                       1/1     Running   6 (103m ago)    30h
```
### 3. Создание тестового приложения
___
Подготовлено тестовое приложение, эмулирующее основное приложение разрабатываемое нашей компанией.

Способ подготовки:
- Создан отдельный [GIT репозиторий ![.](img/img_03.png)](idm-web-app/conf) с простым nginx конфигом, который будет отдавать статические данные.  
- Подготовлен Dockerfile для создания образа приложения.  

Результат:

- [GIT репозиторий ![.](img/img_03.png)](idm-web-app) с тестовым приложением и [Dockerfile ![.](img/img_01.png)](idm-web-app/Dockerfile).
- Репозиторий с собранным docker image. В качестве репозитория использовался [DockerHub ![.](img/img_03.png)](https://hub.docker.com/repository/docker/t585585/idm-web-app/general).
___

### 4. Подготовка системы мониторинга и деплой приложения
___
На этом этапе был использован пакет `kube-prometheus`, который уже включает в себя `Kubernetes оператор` для `grafana`, `prometheus`, `alertmanager` и `node_exporter` и задеплоен в кластер для мониторинга основных метрик Kubernetes.

Задеплоено тестовое приложение `nginx` - сервер отдающий статическую страницу.

Результат:
- [GIT репозиторий ![.](img/img_03.png)](idm-web-app/k8s) с конфигурационными файлами для настройки Kubernetes.
- [HTTP доступ ![.](img/img_02.png)](http://idm.4ivt.ru:30000) к web интерфейсу grafana. 
- Дашборды в grafana отображающие состояние Kubernetes кластера. [![.](img/img_00.png)](img/img_41.jpg)
- [HTTP доступ ![.](img/img_02.png)](http://idm.4ivt.ru:30080) к тестовому приложению. 
___

### 5. Установка и настройка CI/CD
___
Настроен автоматический процесс CI/CD (Continuous Integration/Continuous Deployment) с использованием GitHub Actions. Процесс включает в себя сборку Docker образа, пуш образа в Docker Hub и деплой приложения в Kubernetes кластер при наличии нового тега.

Результат:

Интерфейс CI/CD сервиса доступен по [HTTP ![.](img/img_02.png)](https://github.com/t585585/ci-cd/actions).

1. **Сборка Docker образа**: При каждом коммите в ветку `main` запускается процесс сборки Docker образа.

2. **Пуш образа в Docker Hub**: Собранный образ автоматически пушится в Docker Hub под указанным именем пользователя и именем репозитория.

3. **Деплой в Kubernetes**: Если коммит содержит тег, процесс CI/CD автоматически собирает образ, пушит его в репозиторий с тэгом и деплоит приложение в Kubernetes кластер.


UPD. Настроен автоматический запуск и применение конфигурации terraform из [git-репозитория](https://github.com/t585585/IDM/actions) в `GitHub Action` при любом комите в main ветку. (Пока идет проверка работы и возможны правки - настроил запуск `workflow` при присвоении любого `tag` в ветке `main`)

[ссылка на action](https://github.com/t585585/IDM/actions/runs/7987717283)
