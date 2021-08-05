#!/bin/bash
echo "password123" | sudo -S yum update -y
echo "password123" | sudo -S yum install -y centos-release-scl
echo "password123" | sudo -S yum install -y epel-release
echo "password123" | sudo -S yum install -y python-setuptools
echo "password123" | sudo -S yum install -y rh-python3 
echo "password123" | sudo -S scl enable rh-python3 bash
echo "password123" | sudo -S easy_install pip==20.3.4
echo "password123" | sudo -S python -m pip install pyOpenSSL cryptography




# pass="password123"

# yums=(
#     python3
#     epel-release
#     python-pip
#     openssl
#     python-setuptools
#     )

# pips=(
#     pip
#     pyopenssl
# )

# for i in $yums "${yums[@]}"
# do 
#     echo $pass | sudo -S yum install -y $i
# done

# for i in $pips "${pips[@]}"
# do 
#     echo $pass | sudo -S pip install $i
# done