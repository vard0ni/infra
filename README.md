# DevOps platform

Что доступно на текущий момент:

- Автоматизация развёртывания через Ansible
- Kubernetes v1.32.
- Установку 1ой или несколько control nodes.
- Поддержка high availability (HAProxy + keepalived)
- Среда выполнения контейнеров containerd
- Прописаны параметры для работы с Metallb.
- Сетевой плагин calico.
- Кеширующий DNS сервер на нодах кластера.
- ArgoCD

## Конфигурационные параметры

- [Инвентори](hosts.yaml).
- [Общая конфигурация](group_vars/servers.yaml).

## Установка

### k8s с одной control node

В [инвентори](hosts.yaml) в группе `k8s_masters` необходимо указать только один хост.

```shell
ansible-playbook -b install-cluster.yaml"
```

### k8s с несколькими control nodes

В [инвентори](hosts.yaml) в группе `k8s_masters` необходимо указать **нечётное количество control nodes**.

```shell
ansible-playbook -b install-cluster.yaml"
```

### k8s c high availability

Для работы с high availability в проекте с несколькими 3+ control нодами используются haproxy и keepalived.

Кол-во control нод должно быть нечётным, иначе будут возникать коллизии, так как на этих нодах будут распологаться базы данных etcd, а их должно нечётное кол-во.

В конфиге определяем параметры для доступа к API :

- `ha_cluster_virtual_ip` - виртуальный IP адрес.
- `ha_cluster_virtual_port` - порт. Не должен быть равен 6443.

## Удалить кластер

```shell
ansible-playbook reset.yaml
```
Скрипт удаляет **все** нестандартные цепочки и чистит все стандартные цепочки.

## Апдейт кластера

Необходимо изменить версию кластера в `group_vars\servers.yaml` и запустить апгрейд.

```shell
ansible-playbook upgrade.yaml
```

## Utils

Playbook с утилитами

```shell
ansible-playbook services/06-utils.yaml
```

