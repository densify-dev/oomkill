# oomkill

A trivial test docker image to consume memory continuously and generate OOMKill events on Kubernetes.

**Warning:** use this repository and its docker image `densify/memeater` for testing purposes only, never in production environments!

## Docker image

- [Source code](./memeater/)
- [Docker hub](https://hub.docker.com/r/densify/memeater)

## Usage

For testing of various use-cases, `memeater` can run in one of two modes:

### Main Mode

The main process (`pid 1` of the container) consumes memory continuously in a loop, then sleeps a configurable number of seconds and exits.

This is achieved by running `/home/densify/bin/eatmem.sh`, which is the default CMD of the docker image.

### Forked Mode

The main process (`pid 1` of the container) sleeps a configurable number of seconds, then forks another process which consumes memory continuously in a loop; after the forked process exits (and regardless of its exit code, which is logged), the main process then sleeps a configurable number of seconds and exits.

This is achieved by overriding the docker CMD and running `/home/densify/bin/fork-eatmem.sh` instead.

### Memory Consumption

The memory consumption loop runs a configurable number of times (default: 1,000). Each iteration generates a new POSIX shell variable, which size is determined by another configuration parameter (the default parameter value - 100,000 - indicates memory consumption of about 600,000 bytes); it then sleeps for a configurable number of **microseconds**.

### Environment Variables

The configuration parameters are all passed to the shell scripts as environment variables:

| Environment Variable | Explanation                                               | Default Value | Main               | Forked             |
| -------------------- | --------------------------------------------------------- | ------------- | ------------------ | ------------------ |
| OUTER_SEQ            | memory consumption outer loop range                       | 1,000         | :white_check_mark: | :white_check_mark: |
| INNER_SEQ            | memory consumption inner loop range                       | 100,000       | :white_check_mark: | :white_check_mark: |
| LOOP_INTERVAL  | memory consumption loop sleep (microseconds)              | 1,000,000     | :white_check_mark: | :white_check_mark: |
| AFTER_LOOP_INTERVAL  | sleep after memory consumption loop (seconds)             | 2,600         | :white_check_mark: | :white_check_mark: |
| BEFORE_FORK_INTERVAL | sleep before forking memory consumption process (seconds) | 10            |                    | :white_check_mark: |
| AFTER_FORK_INTERVAL  | sleep after forked process exits (seconds)                | 360           |                    | :white_check_mark: |

## Examples

### [Main container, main mode](./examples/pod-oom.yaml)

### [Main container, forked mode](./examples/pod-oom-forked.yaml)

The following two examples refer to a sidecar container. By sidecar we mean the “classic” sidecar, i.e. `containers[n], n > 0` - and not the [special-case-init-container lifecycle introduced at Kubernetes 1.29](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/).

### [Sidecar container, main mode](./examples/pod-sidecar-oom.yaml)

### [Sidecar container, forked mode](./examples/pod-sidecar-oom-forked.yaml)
