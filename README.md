_This project has been created as part of the 42 curriculum by lcamerly._

---

# Inception

## Description

Inception is a project that teaches us to use Docker and build architecture from scratch. The idea is to set up a Docker Compose cluster containing WordPress, a database, a reverse proxy, and in my case, a Redis cache and a monitoring solution on top.

Every image is built from `Alpine`, every service is configured manually. The trickiest part was making them all talk to each other properly, through networks and volumes. I also had to write a few scripts to setup everything automatically.

As someone revisiting this project with significant Docker experience, I wanted to get it to the next level. I wanted a truly professional project.


---

## Instructions

### Requirements

- Docker >= 28
- _(Optional)_ Make >= 4.3
- Access to Docker Hub

### Running the project

```bash
make
```

That's it! Containers will start automatically

Services are accessible as follows :
WordPress -> `https://lcamerly.42.fr`
Beszel -> `https://lcamerly.42.fr/beszel`
Adminer -> `https://lcamerly.42.fr/adminer`

```bash
make down     # Stop containers
make clean    # Remove containers and volumes
make fclean   # Full cleanup including images
```

---

## Resources

#### Documentation

- [Docker Documentation](https://docs.docker.com/) &&  [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Redis Documentation](https://redis.io/docs/)
- [Beszel Documentation](https://beszel.dev/guide/what-is-beszel)
- [MariaDB Documentation](https://mariadb.com/docs/)
- [WordPress CLI Documentation](https://developer.wordpress.org/cli/commands/)
- [DevSecOps Blog](https://blog.stephane-robert.info/docs/)

#### AI Usage

I used AI in this project for :

- Debugging and quick-fixes (like typos or conf issues)
- Script review: Improving readability and log output in scripts
- Documentation: Cleaning up grammar and phrasing in this README

## Feature List

Beyond the mandatory features from the subject, I added:

- **Redis Cache**
- **Adminer** : DB Administration
- **Beszel** : Simple monitoring solution
- **Healthchecks** 
- **Multi-stage builds** 
- **Everything is behind the reverse proxy**


## Project description

Here's a diagram of the overall architecture defined in the ``docker-compose``:

- Green arrows represent network connections with explicit ports between containers.
- Red arrows represent connections made using domain names.


There are also named volumes mounted in ``/home/$USER/data/`` :

```docker-compose.yml
volumes:
	mariadb:
		driver: local
		driver_opts:
		  type: none
		  o: bind
		  device: /home/lcamerly/data/mariadb
	wordpress-files:
		driver: local
		driver_opts:
		  type: none
		  o: bind
		  device: /home/lcamerly/data/wordpress-files
```

There's one folder for every service in ``/srcs/``. It contains the Dockerfile as well as configuration files. 

> [!note]
> The Docker-Compose also contains a bind-mount for ``Beszel`` to access ``/var/run/docker.sock`` to be able to monitor containers.
> The subject specifies bind-mounts are forbidden for website files and DB volumes only.

Dockerfiles are pretty straightforward. It always follows the same process : 

1. Setting up dependencies (``apk add`` for example)
2. Fetching sources and applying permissions (``COPY``, ``RUN chmod``)
3. Container main process (``CMD`` or ``ENTRYPOINT``)

*This is the baseline. Of course, it might be a little different from time to time with extra instructions!*

> [!note]
> The difference between ``CMD`` and ``ENTRYPOINT`` is that ``CMD`` can be overridden :
> ```Dockerfile
> FROM debian:trixie
> ENTRYPOINT ["/bin/ping"]
> CMD ["localhost"]
>```
> Running the container with ``$ docker run -it test google.com`` will be overwrite `localhost` by `google.com`
>

### Virtual Machines vs Docker

Virtual machines are completely virtualized environments. On a VM, CPU Cores become vCPU, RAM is split between the VM and the host. It creates a whole new filesystem, it needs a hypervisor, a bootloader, etc...
Docker containers are just processes that think they are alone on the host. It uses the power of namespaces. Namespaces allow a process to change its view of itself. It's defined by the kernel : 

- ``PID`` (Processes tree, the container sees itself as PID 1)
- ``Net``(networks)
- ``Mnt``(fs)
- ``Uts`` (hostname)
- ``User`` (GIDs, UIDs)

``Namespaces`` are taking care visibility of everything but it cannot restrict components usages. That's where ``cgroups`` comes in!
``cgroups`` is used by the kernel to split resources between processes and restrict them.

*To be more precise, it's ``containerd + runc`` that does the abstraction job (that's why Kubernetes is able to achieve the same thing!)*
This way, a container is just a process that sees itself with PID 1, with its own hostname, filesystem, etc... And that's why Docker is so lightweight, it just uses some kernel abstraction to create processes that think they are alone. 

### Secrets vs Environment Variables

Environment variables are the unsafe version of Docker secrets. They are stored in the environment of a container at runtime, which means they can be read by anyone with access to the container `docker inspect`, `docker history` or simply by running `env` inside it:

```bash
$ docker run alpine:latest env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=a768832a3d92
HOME=/root
```

Docker secrets solve this by never injecting sensitive values into the environment at all. Instead, the secret is mounted as a file inside the container at `/run/secrets/<secret_name>` and only the processes that explicitly read that file can access it. It's never visible via `docker inspect`, never in the process environment, and never in your Compose file in plain text.

```bash
$ cat /run/secrets/db_password
mySup3rS3cretPassword
```

The tradeoff is that your application needs to know to read from a file rather than from an environment variable — a small but real change in how you write your entrypoints and config loading.

| Method                               | Security      | Persistence                                    | Use case                                         |
| ------------------------------------ | ------------- | ---------------------------------------------- | ------------------------------------------------ |
| Environment variables                | ⚠️ Weak       | For the lifetime of the container              | Debugging, local development                     |
| Docker Secrets (readonly bind mount) | ✅ Medium      | File on the host                               | Simple production setups                         |
| tmpfs                                | ✅✅ High       | Stored in RAM (lost on container stop/restart) | Ephemeral secrets, security-sensitive workloads  |
| Docker Swarm secrets                 | ✅✅ High       | Encrypted at rest                              | Swarm clusters                                   |
| Vault / External secret manager      | ✅✅✅ Very high | External                                       | Enterprise environments, compliance requirements |
*[Source](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/secrets/#injection-au-runtime--autres-m%C3%A9thodes) - Translated by me*


### Docker Network vs Host Network

We'll start with the simpler ones:

1. **None**: A container with no network at all. Total isolation, maximum security but no connectivity!
2. **Macvlan / IPvlan**: They're used to make containers appear as **physical devices directly on your LAN**, each with their own identity. The difference: Macvlan gives each container its own MAC address, while IPvlan shares the host's MAC address and only assigns unique IPs. Useful when you need containers to be reachable like real machines on the network.

The cool stuff :

3. **Overlay**:  Multi-host networking. Containers on different physical machines can talk to each other as if they were on the same network, with native support of TLS encryption and distributed DNS (so container names just work). This is Docker Swarm's native network driver — Kubernetes uses a similar concept but through its own CNI plugins, not Docker's Overlay directly.
4. **Bridge**: The default network mode. Every container gets an `eth0` interface and Docker handles the routing. One important nuance: the **default** bridge doesn't support DNS resolution between containers :  you have to reference them by IP. **Custom** bridge networks do support it, meaning containers can reach each other by their name. That's why creating your own bridge is strongly recommended over using the default one!
5. **Host**: Disables network isolation entirely: the container shares the host's network interfaces directly. Better performance (no NAT overhead), but raises a security concern : a compromised container could access the host network freely. Available on Linux only.

### Docker Volumes vs Bind Mounts

Both are ways to persist data outside a container's lifecycle or to "inject" data inside a container.

A **bind mount** is simple: you point Docker to an existing path on your host (`/home/user/data`) and it gets mounted directly into the container. What the container writes, you see on your host in real time. Great for local development where you want live code reload, but it means your setup is tied to a specific host path — not very portable because very dependant of your filesystem and project structure. It needs careful use of permissions though.

A **Docker volume** lets Docker manage the storage for you. It lives under `/var/lib/docker/volumes/` and has no dependency on your host's directory structure. You reference it by name, not by path. It's the recommended approach for anything that needs to survive container restarts (databases, uploads, generated files, etc...).
