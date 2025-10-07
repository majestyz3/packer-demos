Two quick demos are available: one using Ansible to configure a base RHEL 10 image with Apache installed, and another that builds on the base image to install Podman.

> *Note: Ensure you have updated the `example.pkvars.hcl` file with your specific values before running the demos.*

## Authentication

Review the authentication section for AWS. 

[Packer - Amazon Authentication](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon#authentication)

## Steps
1. Run the base demo:
    ```sh
    cd ./base/
    packer init .
    packer build -force -var-file=example.pkvars.hcl . 
    ```

2. If the base demo completes successfully, navigate to the `../app/` directory and run the app demo:
    ```sh
    cd ../app/
    packer init .
    packer build -force -var-file=example.pkvars.hcl .
    ```

