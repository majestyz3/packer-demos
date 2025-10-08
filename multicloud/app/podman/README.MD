You need a base rhel 10 image for this demo to work. 

1. If the base demo completes successfully, navigate to the `../app/` directory and run the app demo:
    ```sh
    cd ../app/
    packer init .
    packer build -force -var-file=example.pkvars.hcl .
    ```