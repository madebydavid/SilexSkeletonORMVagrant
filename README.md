# Silex Skeleton ORM Vagrant

## This is a Vagrant configuration for [madebydavid/silex-skeleton-orm](https://github.com/madebydavid/SilexSkeletonORM). Built to get development up and running quickly for the skeleton.

### 1. Install the dependencies if you do not already have them

- VirtualBox ([Download Page](https://www.virtualbox.org/wiki/Downloads)]
- Vagrant ([Download Page](https://www.vagrantup.com/downloads))

### 2. Clone this repository into a directory with a new name for your project
```bash
$ git clone git@github.com:madebydavid/SilexSkeletonORMVagrant.git my-silex-app
$ cd my-silex-app
$ git submodule update --init --recursive
```

### 3. Start the virtual machine, the provisioner will create the project for you
```bash
$ vagrant up
```

### 4. The skeleton project will be created inside the www directory. 

To configure the project and build your model, you can follow the instructions from the skeleton [here](https://github.com/madebydavid/SilexSkeletonORM#3-configure-the-database-in-the-dev-config-file).

### 5. Orphan the clone and create a new git repository.
It can be a good idea to remove references to this project from your clone and then create a new git repository with just the created skeleton. To do that quickly:
```bash
$ rm -rf .git
$ cd www
$ git init
```

