# Composer Puppet Module

This module manages Composer installation and usage. It is a fork of a module authored by Thomas
Ploch <profiploch@gmail.com>.

## Description

The `puppet-composer` module installs the latest version of Composer from http://getcomposer.org.
Composer is a dependency manager for PHP.

## Supported Platforms

* `Debian`
* `Redhat`
* `Centos`
* `Amazon Linux`

## Dependencies

This module requires the following Puppet modules:

* [`puppetlabs-git`](https://github.com/puppetlabs/puppetlabs-git/)

And additional (for puppet version lower than 3.0.0) you need:

* [`libaugeas`](http://augeas.net/) (For automatically updating php.ini settings for suhosin patch)

## Usage
To install the `composer` binary globally in `/usr/local/bin` you only need to declare the
`composer` class. We try to set some sane defaults. There are also a number of parameters you can
tweak should the defaults not be sufficient.

### Simple Include
To install the binary with the defaults you just need to include the following in your manifests:

    include composer

### Full Include
Alternatively, you can set a number of options by declaring the class with parameters:

```puppet
class { 'composer':
    target_dir      => '/usr/local/bin',
    composer_file   => 'composer', # could also be 'composer.phar'
    download_method => 'curl',     # or 'wget'
    logoutput       => false,
    tmp_path        => '/tmp',
    php_package     => 'php5-cli',
    curl_package    => 'curl',
    wget_package    => 'wget',
    composer_home   => '/root',
    php_bin         => 'php', # could also i.e. be 'php -d "apc.enable_cli=0"' for more fine grained control
    suhosin_enabled => true,
}
```

### Creating Projects

The `composer::project` definition provides a way to create projects in a target directory.

```puppet
composer::project { 'silex':
    project_name   => 'fabpot/silex-skeleton',  # REQUIRED
    target_dir     => '/vagrant/silex', # REQUIRED
    version        => '2.1.x-dev', # Some valid version string
    prefer_source  => true,
    stability      => 'dev', # Minimum stability setting
    keep_vcs       => false, # Keep the VCS information
    dev            => true, # Install dev dependencies
    repository_url => 'http://repo.example.com', # Custom repository URL
    user           => undef, # Set the user to run as
}
```

#### Updating Packages

The `composer::exec` definition provides a more generic wrapper arround composer `update` and
`install` commands. The following example will update the `silex/silex` and `symfony/browser-kit`
packages in the `/vagrant/silex` directory. You can omit `packages` to update the entire project.

```puppet
composer::exec { 'silex-update':
    cmd                  => 'update',  # REQUIRED
    cwd                  => '/vagrant/silex', # REQUIRED
    packages             => ['silex/silex', 'symfony/browser-kit'], # leave empty or omit to update whole project
    prefer_source        => false, # Only one of prefer_source or prefer_dist can be true
    prefer_dist          => false, # Only one of prefer_source or prefer_dist can be true
    dry_run              => false, # Just simulate actions
    custom_installers    => false, # No custom installers
    scripts              => false, # No script execution
    interaction          => false, # No interactive questions
    optimize             => false, # Optimize autoloader
    dev                  => false, # Install dev dependencies
    user                 => undef, # Set the user to run as
    refreshonly          => false, # Only run on refresh
}
```

#### Installing Packages

We support the `install` command in addition to `update`. The install command will ignore the
`packages` parameter and the following example is the equivalent to running `composer install`
in the `/vagrant/silex` directory.

```puppet
composer::exec { 'silex-install':
    cmd                  => 'install',  # REQUIRED
    cwd                  => '/vagrant/silex', # REQUIRED
    prefer_source        => false,
    prefer_dist          => false,
    dry_run              => false, # Just simulate actions
    custom_installers    => false, # No custom installers
    scripts              => false, # No script execution
    interaction          => false, # No interactive questions
    optimize             => false, # Optimize autoloader
    dev                  => false, # Install dev dependencies
}
```

## Releases

### v1.0.1

* Clarified license, as required by Puppet Forge.

### v1.0.0

* Added `$timeout` param to *exec.pp*. Note that absent an explicit value, Puppet defaults to 300
seconds, which is often not long enough to complete dependency installations.

### v1.2.1

The ORIS edition of the module was forked from [tPl0ch/composer][1], at this tag.


[1]:    https://forge.puppetlabs.com/tPl0ch/composer/1.2.1 "tPl0ch/composer v1.2.1, on the forge"
