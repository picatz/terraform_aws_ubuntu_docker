# Check if ssh-keygen installed.
if [ ! $(which ssh-keygen) ]; then
  echo "Need to install ssh-keygen first!"
  exit 1
fi

# Initialize terraform.
if [ ! -d ".terraform" ]; then
  terraform init
fi

# Create ubuntu_ssh key, if not created.
if [ ! -f "ubuntu_ssh" ]; then
  ssh-keygen -f ubuntu_ssh -t rsa -b 4096 -N ''
fi
