# Ansible Packer Demos

This repository contains demonstration projects using [Ansible](https://www.ansible.com/) with [Packer](https://www.packer.io/) for automated image building.

## Prerequisites

- [Packer](https://www.packer.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Supported cloud provider CLI tools (e.g., AWS CLI, Azure CLI, etc.)

## Structure

- `packer/` — Packer templates and configuration files
- `ansible/` — Ansible playbooks and roles
- `README.md` — Project documentation

## Usage

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/packer-demos.git
    cd packer-demos/ansible
    ```

2. Customize variables in the Packer and Ansible files as needed.

3. Build an image:
    ```sh
    packer build packer/template.json
    ```

## Resources

- [Packer Documentation](https://www.packer.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)

## License

This project is licensed under the MIT License.

![alt text](imgs/pricing-tiers.png)