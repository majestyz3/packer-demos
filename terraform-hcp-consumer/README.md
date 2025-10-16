# 🔐 HCP Terraform + HCP Packer Consumer Demo (with Agent Execution & AWS STS Support)

This demo shows how to deploy EC2 instances using **HCP Terraform** and **HCP Packer**, enforcing image governance and security guardrails via an **HCP Packer Run Task**.  
It also supports **IP-restricted and temporary AWS credentials (STS tokens)** by running Terraform through an **HCP Terraform Agent** within your own network.

---

## 🧱 Key Features

✅ Fetches the latest approved AMI from HCP Packer (`rhel-base` bucket, `production` channel)  
✅ Automatically uses your **default VPC** if subnet/security group are not provided  
✅ Runs Terraform **inside your network** using an **HCP Agent** (for IP-restricted creds)  
✅ Supports `AWS_SESSION_TOKEN` for temporary AWS credentials  
✅ Enforces image compliance via an **HCP Packer Run Task** before every apply  
✅ Demonstrates full Packer → Terraform → AWS integration securely  

---

## 🗂️ Project Structure

terraform-hcp-consumer/
├─ compute.tf
├─ hcp-channels.tf
├─ image.tf
├─ outputs.tf
├─ providers.tf
├─ variables.tf
├─ versions.example.tf
├─ example.auto.tfvars.example
└─ versions.tf # your real config

yaml
Copy code

---

## ⚙️ Setup

### 1️⃣ Prepare Local Files

```bash
git clone https://github.com/<you>/packer-demos.git
cd packer-demos/terraform-hcp-consumer

cp versions.example.tf versions.tf
cp example.auto.tfvars.example example.auto.tfvars
Then edit:

versions.tf → Fill in your HCP organization (and optional project name if you want to place the workspace inside Packer_D)

example.auto.tfvars → Optionally specify a subnet or security group (or leave blank to use your default VPC)

2️⃣ Login and Initialize
bash
Copy code
terraform login
terraform init
Terraform will create or connect to the remote workspace (hcp-packer-ht-demo) in your HCP org.

3️⃣ Add Variables in HCP Terraform
In your workspace (hcp-packer-ht-demo) → Variables tab.

Terraform Variables
Name	Example Value	Description
aws_region	us-east-1	Region to deploy into
(optional) subnet_id	subnet-xxxxxx	Override default subnet
(optional) security_group_id	sg-xxxxxx	Override default security group
(optional) instance_type	t3.micro	Instance type

Environment Variables (Sensitive)
If you’re using long-lived or STS (temporary) credentials, set these:

Name	Description
AWS_ACCESS_KEY_ID	Your access key
AWS_SECRET_ACCESS_KEY	Your secret key
AWS_SESSION_TOKEN	Your STS session token (required if using temporary creds)
(optional) AWS_DEFAULT_REGION	us-east-1

🧠 Tip: If you run multiple workspaces with the same AWS credentials, create a Variable Set in HCP Terraform → attach it to all relevant workspaces.

4️⃣ (Optional) Specify Project
In versions.tf, the project name is optional.
If you uncomment the block below, the workspace will be created in that project (e.g., Packer_D):

hcl
Copy code
# Optional: uncomment to set a project
# workspaces {
#   project = "Packer_D"
#   name    = "hcp-packer-ht-demo"
# }
If left commented, the workspace will live in your default project.

5️⃣ Add the HCP Packer Run Task
In HCP Terraform:

Go to Integrations → Run tasks → Add

Choose HCP Packer

Scope: hcp-packer-ht-demo

Stage: Pre-plan

Constraints:

Bucket: rhel-base

Channel: production

Save.

✅ The Run Task ensures Terraform can only use images approved in HCP Packer.

🧠 Handling IP-Restricted or STS-Based AWS Credentials
If your AWS credentials are valid only from specific IPs or are temporary STS tokens,
you must run Terraform through an HCP Terraform Agent — so AWS calls originate from your allowed network.

6️⃣ Create an HCP Terraform Agent Pool
In HCP Terraform:

Settings → Agents → New Agent Pool

Name it: packer-demo-pool

Copy the registration token displayed.

7️⃣ Launch a Host for the Agent
Create an EC2 instance inside your network (same egress IP as your AWS policy allows).
SSH into it, then install the agent:

bash
Copy code
sudo apt update -y && sudo apt install -y unzip curl
curl -fsSLo tfc-agent.zip https://releases.hashicorp.com/tfc-agent/1.16.0/tfc-agent_1.16.0_linux_amd64.zip
unzip tfc-agent.zip
sudo mv tfc-agent /usr/local/bin/
8️⃣ Register the Agent
bash
Copy code
export TFC_AGENT_TOKEN="<YOUR_AGENT_POOL_TOKEN>"
tfc-agent -token "$TFC_AGENT_TOKEN" -name "packer-demo-agent-1"
You should see:

css
Copy code
INFO[0000] Agent successfully registered and connected to Terraform Cloud
9️⃣ Run Agent as a Service (Recommended)
To keep the agent persistent:

bash
Copy code
sudo tee /etc/systemd/system/tfc-agent.service <<EOF
[Unit]
Description=Terraform Cloud Agent
After=network.target

[Service]
ExecStart=/usr/local/bin/tfc-agent -token ${TFC_AGENT_TOKEN} -name "packer-demo-agent-1"
Restart=always
Environment="TFC_AGENT_TOKEN=${TFC_AGENT_TOKEN}"
User=ubuntu

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable tfc-agent
sudo systemctl start tfc-agent
sudo systemctl status tfc-agent
🔗 10️⃣ Connect Workspace to Agent Pool
In HCP Terraform:

Go to your workspace → Settings → Execution Mode

Select Agent

Choose the pool: packer-demo-pool

Save.

✅ Terraform will now run inside your network — all AWS API calls originate from your agent’s IP, satisfying IAM restrictions.

🧪 11️⃣ Run the Demo
bash
Copy code
terraform plan
terraform apply -auto-approve
What happens:

Ensures the production channel exists in your HCP Packer bucket.

Pulls the latest AMI from that channel.

Deploys an EC2 instance using that AMI.

Tags the AMI with Environment=production.

Validates compliance via the Run Task.

🧨 Negative Test (Compliance Check)
Edit compute.tf and hardcode a random AMI:

hcl
Copy code
ami = "ami-1234567890abcdef0"
Run:

bash
Copy code
terraform plan
The Run Task will fail the plan — proving enforcement works.
Revert the change and re-run for success ✅.

🔁 Promotion / Rollback Demo
Promote a new image to production in HCP Packer.

Run terraform plan → it picks up the new AMI automatically.

Reassign the channel to the prior iteration → plan again → shows rollback.

No code changes needed — it’s all driven by HCP metadata.

🧹 Cleanup
bash
Copy code
terraform destroy -auto-approve
To stop the agent service:

bash
Copy code
sudo systemctl stop tfc-agent
sudo systemctl disable tfc-agent
🧾 Notes
Leaving subnet_id and security_group_id unset automatically uses your default VPC.

The project name in versions.tf is optional — omit it to use your default project.

If you use temporary STS credentials, you must include AWS_SESSION_TOKEN in your environment variables.

The HCP Agent allows IP-restricted or VPN-only setups to execute securely and still use Run Tasks.