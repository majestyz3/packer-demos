hcp_packer_registry {
  bucket_name = "rhel-base"

  description = <<EOT
Some nice description about the image which artifact is being published to HCP Packer Registry. =D
  EOT

  bucket_labels = {
    "team" = "rhel",
    "os"   = "rhel"
  }
}

build {
  sources = [
    "source.amazon-ebs.rhel_10",
    # "source.amazon-ebs.rhel_9"
  ]

  #   provisioner "shell" {
  #     inline = [
  #       "sudo yum install -y httpd",
  #       "sudo systemctl enable httpd"
  #     ]
  #   }

  // Add Mondoo SBOM generation
  provisioner "shell" {
    inline = [
      "bash -c \"$(curl -sSL https://install.mondoo.com/sh)\"",
      "cnquery sbom --output cyclonedx-json --output-target /tmp/sbom_cyclonedx.json",
    ]
  }

  provisioner "ansible" {
    playbook_file = "playbook.yml"
  }

  provisioner "hcp-sbom" {
    source      = "/tmp/sbom_cyclonedx.json"
    destination = "./sbom"
    sbom_name   = "sbom-cyclonedx"
  }


}
