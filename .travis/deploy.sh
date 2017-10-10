#!/bin/bash

openssl aes-256-cbc -K $encrypted_d82c54a77d81_key -iv $encrypted_d82c54a77d81_iv in .travis/id_rsa_github.enc -out ~/.ssh/id_rsa_github -d
chmod 600 ~/.ssh/id_rsa_github
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa_github
cp .travis/ssh_config ~/.ssh/config
git config --global user.name "Jsonya"
git config --global user.email jsonya@163.com
git clone git@github.com:Jsonya/jsonya.github.io.git .deploy
npm run deploy