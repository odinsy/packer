#!/bin/sh -eux

apt-get -y install vim curl mc atop
curl -L https://www.opscode.com/chef/install.sh | sudo bash
