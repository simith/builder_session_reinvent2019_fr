sudo apt-get install gawk gperf grep gettext python python-dev automake bison flex texinfo help2man libtool libtool-bin make help2man texinfo   libtool-bin jq cmake jq -y

sudo snap install cmake --classic

mkdir toolchain
cd toolchain
wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
tar -zxvf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

echo "export PATH=$PATH:/home/ubuntu/environment/toolchain/xtensa-esp32-elf/bin" >> ~/.bash_profile
echo "export IDF_PATH=/home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/amazon-freertos/vendors/espressif/esp-idf" >> ~/.bash_profile

