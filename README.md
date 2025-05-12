# Установка кластера Kubernetes при помощи Ansible

Что доступно на текущий момент:

- Kubernetes v1.32.
- Установку 1ой или несколько control nodes.
- Поддержка high availability
- Среда выполнения контейнеров containerd/cri-o
- Прописаны параметры для работы с Metallb.
- Сетевой плагин calico.
- Кеширующий DNS сервер на нодах кластера.


## Install ansible

```shell
python -m venv venv
. ~/venv/bin/activate
pip install "ansible-core"
ansible-galaxy collection install community.general kubernetes.core ansible.posix
```

Генерация ssh ключа:

```shell
ssh-keygen
```

Копируем ключы в виртуальные машины из [hosts.yaml](hosts.yml):

 ```shell
ssh-copy-id root@c1.gapeev.local
ssh-copy-id root@c2.gapeev.local
ssh-copy-id root@c3.gapeev.local
ssh-copy-id root@w1.gapeev.local
ssh-copy-id root@w2.gapeev.local
```

## Конфигурационные параметры

- [Инвентори](hosts.yaml).
- [Общая конфигурация](group_vars/servers.yaml).

## Установка

### k8s с одной control node

В [инвентори](hosts.yaml) в группе `k8s_masters` выбранного дистрибутива необходимо указать только один хост.

```shell
ansible-playbook -b install-cluster.yaml"
```

### k8s с несколькими control nodes

В [инвентори](hosts.yaml) в группе `k8s_masters` выбранного дистрибутива необходимо указать **нечётное количество control nodes**.

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

**Внимание!!!** Скрипт удаляет **все** нестандартные цепочки и чистит все стандартные цепочки.

## Апдейт кластера

Изменяете версию кластера в `group_vars\servers.yaml` и запускаете апгрейд.

```shell
ansible-playbook upgrade.yaml
```

## Utils playbook

Playbook с утилитами.

```shell
ansible-playbook services/06-utils.yaml
```

## Сервисные функции

Сервисные функции находятся в директории `services`.
