Selenium Vagrant machine for Menta tests
=========================
*Based on https://github.com/seanbuscay/vagrant-phpunit-selenium

## How to use

#### Step 1: (Optional) Add your local domains into ```domains.txt``` if you want to test site from your local machine

```
magento.local
mostrami-dev.local
```
#### Step 2: Start the Vagrant Box

Start the Vagrant Box with:

```
vagrant up
```

It will take several minutes to configure the virtual machine when running this command for the first time. Subsequent runs will be much faster.  

#### Step 3: Menta configuration

```xml
<var name="testing.selenium.seleniumServerUrl" value="http://192.168.2.200:4444/wd/hub"/>
```
#### Optional

```xml
<var name="testing.selenium.browser" value='firefox'/>
```

or

```xml
<var name="testing.selenium.browser" value='chrome'/>
```

#### Vagrant machine


```IP:  192.168.2.200```

After you have started the virtual machine, you may ssh into the virtual machine with the following command:

```
vagrant ssh
password: vagrant
```




