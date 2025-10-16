locals (
  instana_agent_key = vault("secrets/data/instana", "agent_key")
)


hcp_packer_registry {
  bucket_name = "multicloud-rhel-instana-base"

  description = <<EOT
Some nice description about the image which artifact is being published to HCP Packer Registry. =D
  EOT

  bucket_labels = {
    "team" = "rhel",
    "os"   = "rhel"
    "o11y" = "instana"
  }
}

build {
  sources = [
    "source.amazon-ebs.rhel_10",
    "source.azure-arm.rhel_10",
  ]

  provisioner "shell" {
    file = templatefile("./scripts/instana.sh.tpl", {
      instana_agent_key = locals.instana_agent_key
    })
  }

  // Add Mondoo SBOM generation
  // This could be pulled in as a script file, but showing inline for demo purposes. 
  provisioner "shell" {
    inline = [
      "bash -c \"$(curl -sSL https://install.mondoo.com/sh)\"",
      "cnquery sbom --output cyclonedx-json --output-target /tmp/sbom_cyclonedx.json",
    ]
  }

// Upload the SBOM to HCP Packer Registry
// This drops a copy locally in the build directory as well.
  provisioner "hcp-sbom" {
    source      = "/tmp/sbom_cyclonedx.json"
    destination = "./sbom"
    sbom_name   = "sbom-cyclonedx"
  }
}
