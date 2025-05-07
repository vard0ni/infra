# Установка кластера Kubernetes при помощи Ansible playbook

Поддерживает:

- Kubernetes v1.32.
- Установку одной или несколько control nodes.
- HA доступ к API kubernetes.
- CRI-O.
- calico.
- В KubeProxyConfiguration установлены параметры для работы Metallb.
- nodelocaldns - кеширующий DNS сервер на каждой ноде кластера.


## Установка ansible

```shell
python3 -m venv venv
. ~/venv/bin/activate
pip3 install "ansible-core<2.17"
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install kubernetes.core
```

Генерируем ssh ключ:

```shell
ssh-keygen
```

Копируем ключики в виртуальные машины из [hosts.yaml](hosts.yml):

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

### k8s c HA

Используются haproxy и keepalived.

В конфигурационном файле определите параметры доступа к API :

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
