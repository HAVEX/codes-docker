# Docker setup for CODES

Use Docker to install CODES in virtual environments or cloud infrastructure. 

## Setup Docker

### Install Docker in Ubuntu 16.04 64-bit 

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

````

If you want to run Docker commands without "sudo", you can add your username to the docker group:
```
sudo usermod -aG docker ${USER}
```

