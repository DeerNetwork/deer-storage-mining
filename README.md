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

#### Install the deer Scripts

Go to the **deer** folder

```bash
chmod +x install.sh
sudo ./install.sh
```

#### How to use

##### Install

```bash
sudo deer install init
```
Enter information as prompted.

##### Start minner
```bash
sudo deer start all
```
##### Start docker separately
```bash
sudo deer start chain
sudo deer start teaclave
sudo deer start worker
sudo deer start ipfs
```

##### Stop minner
```bash
sudo deer stop all
```
##### Stop docker separately
```bash
sudo deer stop chain
sudo deer stop teaclave
sudo deer stop worker
sudo deer stop ipfs
```

##### Update deer Dockers

###### Update deer dockers without clean data

```bash
sudo deer update images
```
###### Now you can auto update the script 

```bash
sudo deer update script
```

##### Check the docker status

```bash
sudo deer status
```

##### Get Logs

```bash
sudo deer logs chain
sudo deer logs teaclave
sudo deer logs worker
sudo deer logs ipfs
```

##### Check the config of minner


```bash
sudo deer config show
```
##### Setup the config of minner

```bash
sudo deer config set
```