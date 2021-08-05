## Readme

#### Get to Ready

-   #### BIOS Setting

    -   Disabled Secure Boot
    -   Boot Mode must be **UEFI**
    -   SGX Setting，must be **Enabled** or **Software Controlled**

-   Run the **egx_enable** if your SGX setting in BIOS is  **Software Controlled**

```bash
sudo chmod +x sgx_enable
sudo ./sgx_enable
sudo reboot
```

#### Install the nft360 Scripts

Go to the **nft360** folder

```bash
chmod +x install.sh
sudo ./install.sh
```

#### How to use

##### Install

```bash
sudo nft360 install init
```
Enter information as prompted.

##### Start minner
```bash
sudo nft360 start all
```
##### Start docker separately
```bash
sudo nft360 start chain
sudo nft360 start teaclave
sudo nft360 start worker
sudo nft360 start ipfs
```

##### Stop minner
```bash
sudo nft360 stop all
```
##### Stop docker separately
```bash
sudo nft360 stop chain
sudo nft360 stop teaclave
sudo nft360 stop worker
sudo nft360 stop ipfs
```

##### Update nft360 Dockers

###### Update nft360 dockers without clean data

```bash
sudo nft360 update images
```
###### Now you can auto update the script 

```bash
sudo nft360 update script
```

##### Check the docker status

```bash
sudo nft360 status
```

##### Get Logs

```bash
sudo nft360 logs chain
sudo nft360 logs teaclave
sudo nft360 logs worker
sudo nft360 logs ipfs
```

##### Check the config of minner


```bash
sudo nft360 config show
```
##### Setup the config of minner

```bash
sudo nft360 config set
```