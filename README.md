# clab-workbench
[CONTAINERlab](https://containerlab.dev/) workflows inside of Visual Studo Code [development containers](https://code.visualstudio.com/learn/develop-cloud/containers) ([Docker-in-Docker](https://github.com/devcontainers/features/tree/main/src/docker-in-docker))

## Requirements
Follow the requirements provided in the [Prerequisites](https://code.visualstudio.com/learn/develop-cloud/containers#_prerequisites) section for VS Code remote development

## Deployment
* Add this repository to a new or existing VS Code workspace
    * The [.devcontainer.json](.devcontainer/devcontainer.json) file will facilitate the creation of a VS Code development container with Python 3.11 and install CONTAINERlab version 0.45.1
* Follow along with the labs in the [Labs](#labs) section

## Verification
VS Code should automatically open a Terminal with the ```vscode ➜ /workspaces/clab-workbench (main) $``` prompt within the workspace. If it does not, simply open a Terminal and execute ```docker inspect clab-dev --format "{{.State.Status}}"``` to ensure the ```clab-dev``` container is running

## Labs

### Simple FRR EVPN-VXLAN with Layer2 workflows
[simple-evpn-vxlan-l2](labs/simple-evpn-vxlan-l2/README.md)