# oomkill

A trivial test docker image to consume memory continuously and generate OOMKill events on Kubernetes.

**Warning:** use this repository and its docker image `densify/memeater` for testing purposes only, never in production environments!

## Docker image

- [Source code](./memeater/)
- [Docker hub](https://hub.docker.com/r/densify/memeater)

## Usage

For testing of various use-cases, `memeater` can run in one of three modes:

### Main Mode

The main process (`pid 1` of the container) consumes memory continuously in a loop, then sleeps a configurable number of seconds and exits (or waits forever and does not exit, depending on an environment variable).

This is achieved by running `/home/densify/bin/eatmem.sh`, which is the default CMD of the docker image.

### Forked Mode

The main process (`pid 1` of the container) sleeps a configurable number of seconds, then forks another process which consumes memory continuously in a loop; after the forked process exits (and regardless of its exit code, which is logged), the main process then sleeps a configurable number of seconds and exits.

This is achieved by overriding the docker CMD and running `/home/densify/bin/fork-eatmem.sh` instead.

Please note that under Kubernetes, forked mode DOES NOT cause a container restart for versions prior to 1.28. See also [here](https://itnext.io/kubernetes-silent-pod-killer-104e7c8054d9).

### Forked-Many Mode

The main process (`pid 1` of the container) forks a configurable number (`NUM_FORKS`) of `memeater` processes with `AFTER_LOOP_INTERVAL=forever` (i.e. these will consume memory and never exit).

It then runs itself forever and checks for the forked processes (10s intervals). As soon as it detects less processes than `NUM_FORKS` value, it spawns new process/es to complete their number to `NUM_FORKS`.

This is achieved by overriding the docker CMD and running `/home/densify/bin/forkmany.sh` instead.

The comment above concerning container restarts under Kubernetes with versions prior to 1.28 is applicable for forked-many mode as well.

### Memory Consumption

The memory consumption loop runs a configurable number of times (default: 1,000). Each iteration generates a new POSIX shell variable, which size is determined by another configuration parameter (the default parameter value - 100,000 - indicates memory consumption of about 600,000 bytes); it then sleeps for a configurable number of **microseconds**.

### Environment Variables

The configuration parameters are all passed to the shell scripts as environment variables:

| Environment Variable | Explanation | Default | Main | Forked | Forked-Many |
| -------------------- | --------------------------------------------------------- | ------------- | ------------------ | ------------------ | ------------------ |
| `OUTER_SEQ`            | memory consumption outer loop range                       | 1,000         | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `INNER_SEQ`            | memory consumption inner loop range                       | 100,000       | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `LOOP_INTERVAL`  | memory consumption loop sleep (microseconds)              | 1,000,000     | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `AFTER_LOOP_INTERVAL`  | sleep after memory consumption loop (seconds);<br/>value of `forever` prevents the process from exiting | 2,600         | :white_check_mark: | :white_check_mark: | `forever` |
| `BEFORE_FORK_INTERVAL` | sleep before forking memory consumption process (seconds) | 10            |                    | :white_check_mark: | |
| `AFTER_FORK_INTERVAL`  | sleep after forked process exits (seconds)                | 360           |                    | :white_check_mark: | |
| `NUM_FORKS`  | number of processes to fork                | 10           |                    |                    | :white_check_mark: |

## Examples

### Deployment

### Main container, main mode

[Frequent OOM Kills](./examples/deployment-oom-frequent.yaml)

[Slow OOM Kills](./examples/deployment-oom-slow.yaml)

### Main container, forked mode

[Frequent OOM Kills](./examples/deployment-oom-forked-frequent.yaml)

[Slow OOM Kills](./examples/deployment-oom-forked-slow.yaml)

### Main container, forked-many mode

[Frequent OOM Kills](./examples/deployment-oom-forkedmany-frequent.yaml)

[Slow OOM Kills](./examples/deployment-oom-forkedmany-slow.yaml)

### Pod

### [Main container, main mode](./examples/pod-oom.yaml)

### [Main container, forked mode](./examples/pod-oom-forked.yaml)

The following two examples refer to a sidecar container. By sidecar we mean the “classic” sidecar, i.e. `containers[n], n > 0` - and not the [special-case-init-container lifecycle introduced at Kubernetes 1.29](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/).

### [Sidecar container, main mode](./examples/pod-sidecar-oom.yaml)

### [Sidecar container, forked mode](./examples/pod-sidecar-oom-forked.yaml)
