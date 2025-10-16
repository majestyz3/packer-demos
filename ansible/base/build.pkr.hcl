// build.pkr.hcl

build {
  sources = [
    "source.amazon-ebs.rhel_10",
  ]

  // HCP Packer Registry metadata for this build
  hcp_packer_registry {
    bucket_name = "rhel-base"

    description = <<EOT
Some nice description about the image which artifact is being published to HCP Packer Registry. =D
EOT

    bucket_labels = {
      team = "rhel"
      os   = "rhel"
    }
  }

  // Mondoo SBOM generation
  provisioner "shell" {
    inline = [
      "bash -c \"$(curl -sSL https://install.mondoo.com/sh)\"",
      "cnquery sbom --output cyclonedx-json --output-target /tmp/sbom_cyclonedx.json",
    ]
  }

  // Run an Ansible playbook against the instance
  provisioner "ansible" {
    playbook_file = "playbook.yml"
  }

  // Upload the SBOM to HCP Packer Registry (also drops a local copy)
  provisioner "hcp-sbom" {
    source      = "/tmp/sbom_cyclonedx.json"
    destination = "./sbom"
    sbom_name   = "sbom-cyclonedx"
  }
}
