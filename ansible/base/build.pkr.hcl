// This is the Packer Registry, just 
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

  ]

  // Add Mondoo SBOM generation
  // This could be pulled in as a script file, but showing inline for demo purposes. 
  provisioner "shell" {
    inline = [
      "bash -c \"$(curl -sSL https://install.mondoo.com/sh)\"",
      "cnquery sbom --output cyclonedx-json --output-target /tmp/sbom_cyclonedx.json",
    ]
  }

// Ansible provisioner to run the playbook against the instance. 
// Only installs apache httpd for demo purposes.
  provisioner "ansible" {
    playbook_file = "playbook.yml"
  }


// Upload the SBOM to HCP Packer Registry
// This drops a copy locally in the build directory as well.
  provisioner "hcp-sbom" {
    source      = "/tmp/sbom_cyclonedx.json"
    destination = "./sbom"
    sbom_name   = "sbom-cyclonedx"
  }


}
